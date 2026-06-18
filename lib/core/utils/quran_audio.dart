class ReciterInfo {
  final String code;
  final String baseUrl;
  const ReciterInfo({required this.code, required this.baseUrl});
}

class QuranAudio {
  static const Map<String, ReciterInfo> reciters = {
    'العفاسي': ReciterInfo(code: 'afs', baseUrl: 'https://server8.mp3quran.net/afs'),
    'المنشاوي': ReciterInfo(code: 'minsh', baseUrl: 'https://server10.mp3quran.net/minsh'),
    'عبد الباسط': ReciterInfo(code: 'basit', baseUrl: 'https://server7.mp3quran.net/basit'),
    'ماهر المعيقلي': ReciterInfo(code: 'maher', baseUrl: 'https://server12.mp3quran.net/maher'),
    'ياسر الدوسري': ReciterInfo(code: 'yasser', baseUrl: 'https://server11.mp3quran.net/yasser'),
    'محمد اللحيدان': ReciterInfo(code: 'lhdan', baseUrl: 'https://server8.mp3quran.net/lhdan'),
  };

  static String getSurahUrl(int surahNumber, {String reciterCode = 'afs'}) {
    final num = surahNumber.toString().padLeft(3, '0');
    final entry = reciters.values.firstWhere(
      (r) => r.code == reciterCode,
      orElse: () => reciters.values.first,
    );
    return '${entry.baseUrl}/$num.mp3';
  }

  static String getAyahUrl(int surahNumber, int ayahNumber) {
    return 'https://quran.com/audio/ayah/${surahNumber}_$ayahNumber.mp3';
  }
}

class AdhanAudio {
  static const String adhanUrl = 'https://www.islamcan.com/audio/adhan/azan1.mp3';

  static const String adhanMakkahUrl = 'https://www.islamcan.com/audio/adhan/azan_makkah.mp3';
  static const String adhanMadinahUrl = 'https://www.islamcan.com/audio/adhan/azan_madinah.mp3';

  static String getAdhanUrl({bool makkah = true}) {
    return makkah ? adhanMakkahUrl : adhanMadinahUrl;
  }
}
