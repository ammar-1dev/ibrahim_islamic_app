# transforms hadith-json data into app-compatible format
import json
import re
import os

RAW_DIR = '/tmp/hadith_data/AhmedBaset-hadith-json-ca32fd7/db/by_book/the_9_books'
OUT_DIR = '/home/sam/Documents/programming_projects/IbrahimAPP/ibrahim_islamic_app/assets/hadith'

COLLECTIONS = {
    'bukhari': {
        'id': 1,
        'name': 'صحيح البخاري',
        'nameEn': 'Sahih al-Bukhari',
        'author': 'الإمام محمد بن إسماعيل البخاري',
        'source': 'صحيح البخاري',
        'filename': 'bukhari.json'
    },
    'muslim': {
        'id': 2,
        'name': 'صحيح مسلم',
        'nameEn': 'Sahih Muslim',
        'author': 'الإمام مسلم بن الحجاج النيسابوري',
        'source': 'صحيح مسلم',
        'filename': 'muslim.json'
    }
}

def extract_matn(full_text):
    """try to extract just the matn (text without sanad/chain)"""
    # patterns for common sanad endings
    patterns = [
        r'عَنِ النَّبِيِّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ[:]?\s*',
        r'عَنِ النَّبِيِّ صلى الله عليه وسلم قَالَ[:]?\s*',
        r'عَنِ النَّبِيِّ ﷺ قَالَ[:]?\s*',
        r'عَنِ النَّبِيِّ \(ص\) قَالَ[:]?\s*',
        r'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ[:]?\s*',
        r'قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم[:]?\s*',
        r'قَالَ رَسُولُ اللَّهِ ﷺ[:]?\s*',
        r'أَنَّ رَسُولَ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ[:]?\s*',
        r'أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم قَالَ[:]?\s*',
        r'أَنَّ النَّبِيَّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ[:]?\s*',
        r'أَنَّ النَّبِيَّ صلى الله عليه وسلم قَالَ[:]?\s*',
    ]
    
    cleaned = full_text.strip()
    for p in patterns:
        m = re.search(p, cleaned)
        if m:
            after = cleaned[m.end():]
            if len(after) < len(cleaned) * 0.7:  # significant reduction
                return after.strip()
    
    # if no pattern found, return last sentence or portion
    sentences = re.split(r'[.?!]?\s*"[»]|\s*"[«]', cleaned)
    if len(sentences) > 1:
        return sentences[-1].strip()
    
    return cleaned[:500] if len(cleaned) > 500 else cleaned


def transform(file_key):
    info = COLLECTIONS[file_key]
    raw_path = os.path.join(RAW_DIR, f'{file_key}.json')
    
    with open(raw_path, 'r', encoding='utf-8') as f:
        raw = json.load(f)
    
    # build chapter map
    chapter_map = {}
    for ch in raw.get('chapters', []):
        chapter_map[ch['id']] = ch.get('arabic', '')
    
    # build hadiths list
    hadiths = []
    for h in raw.get('hadiths', []):
        arabic = h.get('arabic', '')
        eng = h.get('english', {})
        narrator = eng.get('narrator', '') if isinstance(eng, dict) else ''
        translation = eng.get('text', '') if isinstance(eng, dict) else ''
        
        # clean narrator prefix (remove "Narrated ")
        narrator_clean = re.sub(r'^Narrated\s+', '', narrator).strip().rstrip(':')
        
        chapter_id = h.get('chapterId', 0)
        category = chapter_map.get(chapter_id, '')
        
        hadiths.append({
            'id': h.get('id', 0),
            'number': h.get('idInBook', 0),
            'chapterId': chapter_id,
            'category': category,
            'narrator': narrator_clean,
            'source': info['source'],
            'arabic': arabic,
            'fullArabic': arabic,
            'translation': translation,
        })
    
    result = {
        'id': info['id'],
        'name': info['name'],
        'nameEn': info['nameEn'],
        'author': info['author'],
        'totalHadiths': len(hadiths),
        'chapters': raw.get('chapters', []),
        'hadiths': hadiths,
    }
    
    out_path = os.path.join(OUT_DIR, info['filename'])
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=1)
    
    file_size = os.path.getsize(out_path) / (1024 * 1024)
    print(f'✅ {info["name"]}: {len(hadiths)} hadiths, {len(result["chapters"])} chapters → {out_path} ({file_size:.1f} MB)')
    print(f'   Chapters: {[c.get("arabic", c.get("english", ""))[:40] for c in result["chapters"][:3]]}...')


if __name__ == '__main__':
    os.makedirs(OUT_DIR, exist_ok=True)
    transform('bukhari')
    transform('muslim')
