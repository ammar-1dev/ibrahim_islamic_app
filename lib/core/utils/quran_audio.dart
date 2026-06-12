class QuranAudio {
  static const String _baseUrl = 'https://server8.mp3quran.net/afs';

  static String getSurahUrl(int surahNumber) {
    final num = surahNumber.toString().padLeft(3, '0');
    return '$_baseUrl/$num.mp3';
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
