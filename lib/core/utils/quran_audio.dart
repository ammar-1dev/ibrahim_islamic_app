class QuranAudio {
  static const String _baseUrl = 'https://server8.mp3quran.net/akdr';

  static String getSurahUrl(int surahNumber) {
    final num = surahNumber.toString().padLeft(3, '0');
    return '$_baseUrl/$num.mp3';
  }

  static String getAyahUrl(int surahNumber, int ayahNumber) {
    return 'https://quran.com/audio/ayah/${surahNumber}_$ayahNumber.mp3';
  }
}
