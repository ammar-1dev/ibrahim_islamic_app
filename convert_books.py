import zipfile
import json
import re
import os
import sys

BOOKS_MAP = {
    10655: {"id": 27, "title": "إعلام الموقعين عن رب العالمين"},
    6012: {"id": 28, "title": "مدارج السالكين"},
    751: {"id": 29, "title": "روضة المحبين"},
    67291: {"id": 30, "title": "عدة الصابرين"},
    97057: {"id": 31, "title": "مفتاح دار السعادة"},
    937: {"id": 32, "title": "الطرق الحكمية"},
    5157: {"id": 33, "title": "تحفة المودود"},
    5158: {"id": 34, "title": "الفروسية"},
}

ZIP_DIR = "/tmp/ketabonline_books"
OUTPUT_DIR = "/tmp/ketabonline_books/converted"


def extract_text(html):
    text = re.sub(r'<br\s*/?>', '\n', html)
    text = re.sub(r'<[^>]+>', '', text)
    text = re.sub(r'\s*\n\s*', '\n', text)
    text = re.sub(r'[ \t]+', ' ', text)
    text = re.sub(r'\n{3,}', '\n\n', text)
    text = text.strip()
    return text


def get_leaf_leaves(items, depth=0, part_name=""):
    leaves = []
    for item in items:
        pn = item.get("part_name", part_name)
        if item.get("children"):
            leaves.extend(get_leaf_leaves(item["children"], depth + 1, pn))
        else:
            leaves.append({
                "depth": depth,
                "title": item.get("title", ""),
                "page": item.get("page", 0),
                "part_name": pn or part_name,
            })
    return leaves


def get_ordered_leaves(index):
    all_leaves = []
    for top in index:
        all_leaves.extend(get_leaf_leaves([top], 0, str(top.get("page", 0))))
    return all_leaves


def build_content_for_part(leaves, part_pages):
    if not part_pages:
        return {}

    page_to_content = {}
    for i, leaf in enumerate(leaves):
        page_num = leaf["page"]
        start_idx = None
        for j, p in enumerate(part_pages):
            if p["page"] == page_num:
                start_idx = j
                break
        if start_idx is None:
            continue
        end_idx = len(part_pages)
        for k in range(i + 1, len(leaves)):
            nxt = leaves[k]
            if nxt["page"] > page_num:
                for j, p in enumerate(part_pages):
                    if p["page"] == nxt["page"]:
                        end_idx = j
                        break
                break
        texts = []
        for p in part_pages[start_idx:end_idx]:
            text = extract_text(p["content"])
            if text:
                texts.append(text)
        content = "\n\n".join(texts)
        key = f"{leaf['part_name']}:{page_num}"
        page_to_content[key] = content
    return page_to_content


def convert_book(ketab_id, app_book_id, title):
    zip_path = os.path.join(ZIP_DIR, f"{ketab_id}.data.zip")
    with zipfile.ZipFile(zip_path) as z:
        with z.open(f"{ketab_id}.data.json") as f:
            data = json.loads(f.read())

    index = data["index"]
    pages = data["pages"]

    part_pages_map = {}
    for p in pages:
        part_name = p["part"]["name"]
        part_pages_map.setdefault(part_name, []).append(p)

    all_leaves = get_ordered_leaves(index)
    leaves_by_part = {}
    for leaf in all_leaves:
        pn = leaf["part_name"]
        leaves_by_part.setdefault(pn, []).append(leaf)

    content_cache = {}
    for pn, leaves in leaves_by_part.items():
        content_cache.update(build_content_for_part(leaves, part_pages_map.get(pn, [])))

    def get_content(item, parent_part_name=""):
        pn = item.get("part_name", parent_part_name)
        page_num = item.get("page", 0)
        key = f"{pn}:{page_num}"
        return content_cache.get(key, "")

    chapters = []

    def make_section(item, parent_part_name=""):
        text = get_content(item, parent_part_name)
        return {"title": item.get("title", ""), "text": text} if text else None

    for top in index:
        top_children = top.get("children", [])
        if not top_children:
            text = get_content(top, "")
            if text:
                chapters.append({
                    "title": top.get("title", ""),
                    "sections": [{"title": "", "text": text}],
                })
            continue

        has_grandchildren = any(c.get("children") for c in top_children)
        part_name = top.get("part_name", "")

        if has_grandchildren:
            for child in top_children:
                grandkids = child.get("children", [])
                sections = []
                if grandkids:
                    for gc in grandkids:
                        s = make_section(gc, child.get("part_name", part_name))
                        if s:
                            sections.append(s)
                else:
                    s = make_section(child, part_name)
                    if s:
                        sections.append(s)
                if sections:
                    chapters.append({
                        "title": child.get("title", ""),
                        "sections": sections,
                    })
        else:
            sections = []
            for child in top_children:
                s = make_section(child, part_name)
                if s:
                    sections.append(s)
            if sections:
                chapters.append({
                    "title": top.get("title", ""),
                    "sections": sections,
                })

    output = {
        "id": app_book_id,
        "title": title,
        "chapters": chapters,
    }

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    out_path = os.path.join(OUTPUT_DIR, f"{app_book_id}.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    total_sections = sum(len(ch["sections"]) for ch in chapters)
    total_chars = sum(len(ch["sections"][i]["text"]) for ch in chapters for i in range(len(ch["sections"])))
    print(f"  Book {app_book_id} ({title}): {len(chapters)} chapters, {total_sections} sections, {total_chars} chars")
    return output


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for ketab_id, info in BOOKS_MAP.items():
        print(f"Converting ketab {ketab_id} -> book {info['id']} ({info['title']})")
        try:
            convert_book(ketab_id, info["id"], info["title"])
        except Exception as e:
            print(f"  ERROR: {e}", file=sys.stderr)

    print("\nDone! Output files:")
    for f in sorted(os.listdir(OUTPUT_DIR)):
        fpath = os.path.join(OUTPUT_DIR, f)
        size = os.path.getsize(fpath)
        print(f"  {f}: {size:,} bytes")


if __name__ == "__main__":
    main()
