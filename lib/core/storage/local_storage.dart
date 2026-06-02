import 'package:hive_flutter/hive_flutter.dart';

/// مخزن محلي يلتفّ على Hive لإدارة بيانات المستخدم
class LocalStorage {
  static const String _prayerBox = 'prayer_tracker';
  static const String _settingsBox = 'settings';
  static const String _progressBox = 'progress';
  static const String _bookmarksBox = 'bookmarks';

  // ── Prayer tracking ──────────────────────────────────────
  Future<void> savePrayerStatus(String prayerName, bool done) async {
    final box = Hive.box(_prayerBox);
    final dateKey = _todayKey(prayerName);
    await box.put(dateKey, done);
  }

  bool getPrayerStatus(String prayerName) {
    final box = Hive.box(_prayerBox);
    final dateKey = _todayKey(prayerName);
    return box.get(dateKey, defaultValue: false) as bool;
  }

  int getTodayPrayerCount() {
    final prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    return prayers.where((p) => getPrayerStatus(p)).length;
  }

  String _todayKey(String name) {
    final today = DateTime.now();
    return '${today.year}-${today.month}-${today.day}-$name';
  }

  // ── Settings ──────────────────────────────────────────────
  Future<void> saveString(String key, String value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as String;
  }

  Future<void> saveBool(String key, bool value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as bool;
  }

  // ── Quran progress ────────────────────────────────────────
  Future<void> saveQuranPage(int page) async {
    final box = Hive.box(_progressBox);
    await box.put('quran_current_page', page);
  }

  int getQuranPage() {
    final box = Hive.box(_progressBox);
    return box.get('quran_current_page', defaultValue: 1) as int;
  }

  // ── Bookmarks ─────────────────────────────────────────────
  Future<void> addBookmark(String surahAyah) async {
    final box = Hive.box(_bookmarksBox);
    final List<String> current =
        (box.get('bookmarks', defaultValue: <String>[]) as List).cast<String>();
    if (!current.contains(surahAyah)) {
      current.add(surahAyah);
      await box.put('bookmarks', current);
    }
  }

  Future<void> removeBookmark(String surahAyah) async {
    final box = Hive.box(_bookmarksBox);
    final List<String> current =
        (box.get('bookmarks', defaultValue: <String>[]) as List).cast<String>();
    current.remove(surahAyah);
    await box.put('bookmarks', current);
  }

  List<String> getBookmarks() {
    final box = Hive.box(_bookmarksBox);
    return (box.get('bookmarks', defaultValue: <String>[]) as List)
        .cast<String>();
  }

  bool isBookmarked(String surahAyah) => getBookmarks().contains(surahAyah);

  // ── Azkar progress ────────────────────────────────────────
  Future<void> saveAzkarProgress(String category, int completedCount) async {
    final box = Hive.box(_progressBox);
    final key = '${_todayKey(category)}_azkar';
    await box.put(key, completedCount);
  }

  int getAzkarProgress(String category) {
    final box = Hive.box(_progressBox);
    final key = '${_todayKey(category)}_azkar';
    return box.get(key, defaultValue: 0) as int;
  }

  // ── Spiritual level ───────────────────────────────────────
  Future<void> saveSpiritualLevel(int level) async {
    final box = Hive.box(_progressBox);
    await box.put('spiritual_level', level);
  }

  int getSpiritualLevel() {
    final box = Hive.box(_progressBox);
    return box.get('spiritual_level', defaultValue: 0) as int;
  }

  // ── Initialization ────────────────────────────────────────
  static Future<void> init({String? path}) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    await Hive.openBox(_prayerBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_progressBox);
    await Hive.openBox(_bookmarksBox);
  }
}
