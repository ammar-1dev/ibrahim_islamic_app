#!/usr/bin/env python3
"""
توليد محتوى كتاب أسباب النزول من ملف asbab_al_nuzul.json
"""
import json, os

# Read asbab data
with open('assets/tafsir/asbab_al_nuzul.json', 'r', encoding='utf-8') as f:
    asbab_data = json.load(f)

# Read current book_contents
with open('assets/books/book_contents.json', 'r', encoding='utf-8') as f:
    book_contents = json.load(f)

# Surah names
surah_names = {
    1: "الفاتحة", 2: "البقرة", 3: "آل عمران", 4: "النساء", 5: "المائدة",
    6: "الأنعام", 7: "الأعراف", 8: "الأنفال", 9: "التوبة", 10: "يونس",
    11: "هود", 12: "يوسف", 13: "الرعد", 14: "إبراهيم", 15: "الحجر",
    16: "النحل", 17: "الإسراء", 18: "الكهف", 19: "مريم", 20: "طه",
    21: "الأنبياء", 22: "الحج", 23: "المؤمنون", 24: "النور", 25: "الفرقان",
    26: "الشعراء", 27: "النمل", 28: "القصص", 29: "العنكبوت", 30: "الروم",
    31: "لقمان", 32: "السجدة", 33: "الأحزاب", 34: "سبأ", 35: "فاطر",
    36: "يس", 37: "الصافات", 38: "ص", 39: "الزمر", 40: "غافر",
    41: "فصلت", 42: "الشورى", 43: "الزخرف", 44: "الدخان", 45: "الجاثية",
    46: "الأحقاف", 47: "محمد", 48: "الفتح", 49: "الحجرات", 50: "ق",
    51: "الذاريات", 52: "الطور", 53: "النجم", 54: "القمر", 55: "الرحمن",
    56: "الواقعة", 57: "الحديد", 58: "المجادلة", 59: "الحشر", 60: "الممتحنة",
    61: "الصف", 62: "الجمعة", 63: "المنافقون", 64: "التغابن", 65: "الطلاق",
    66: "التحريم", 67: "الملك", 68: "القلم", 69: "الحاقة", 70: "المعارج",
    71: "نوح", 72: "الجن", 73: "المزمل", 74: "المدثر", 75: "القيامة",
    76: "الإنسان", 77: "المرسلات", 78: "النبأ", 79: "النازعات", 80: "عبس",
    81: "التكوير", 82: "الانفطار", 83: "المطففين", 84: "الانشقاق", 85: "البروج",
    86: "الطارق", 87: "الأعلى", 88: "الغاشية", 89: "الفجر", 90: "البلد",
    91: "الشمس", 92: "الليل", 93: "الضحى", 94: "الشرح", 95: "التين",
    96: "العلق", 97: "القدر", 98: "البينة", 99: "الزلزلة", 100: "العاديات",
    101: "القارعة", 102: "التكاثر", 103: "العصر", 104: "الهمزة", 105: "الفيل",
    106: "قريش", 107: "الماعون", 108: "الكوثر", 109: "الكافرون", 110: "النصر",
    111: "المسد", 112: "الإخلاص", 113: "الفلق", 114: "الناس"
}

# Group entries by surah
surah_groups = {}
for key, text in asbab_data.items():
    parts = key.split(':')
    surah_num = int(parts[0])
    ayah_num = int(parts[1])
    if surah_num not in surah_groups:
        surah_groups[surah_num] = []
    surah_groups[surah_num].append((ayah_num, text))

# Create chapters
chapters = []
for surah_num in sorted(surah_groups.keys()):
    sname = surah_names.get(surah_num, f"سورة {surah_num}")
    entries = sorted(surah_groups[surah_num], key=lambda x: x[0])
    sections = []
    for ayah_num, text in entries:
        sections.append({
            "title": f"الآية {ayah_num}",
            "text": text
        })
    chapters.append({
        "title": f"تفسير سورة {sname}",
        "sections": sections
    })

# Add the new book
book_contents["26"] = {
    "book_id": 26,
    "chapters": chapters
}

# Write back
with open('assets/books/book_contents.json', 'w', encoding='utf-8') as f:
    json.dump(book_contents, f, ensure_ascii=False, indent=2)

total_entries = sum(len(g) for g in surah_groups.values())
print(f"✅ تمت إضافة كتاب أسباب النزول")
print(f"📚 عدد السور المغطاة: {len(chapters)}")
print(f"📄 عدد أسباب النزول: {total_entries}")
