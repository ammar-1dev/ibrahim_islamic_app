import '../../features/hadith/data/hadith_search_index.dart';

class DailyHadith {
  final int id;
  final int number;
  final String category;
  final String narrator;
  final String source;
  final String arabic;
  final String fullArabic;
  final String translation;

  const DailyHadith({
    required this.id,
    required this.number,
    required this.category,
    required this.narrator,
    required this.source,
    required this.arabic,
    required this.fullArabic,
    required this.translation,
  });

  factory DailyHadith.fromJson(Map<String, dynamic> json) => DailyHadith(
        id: json['id'] as int,
        number: json['number'] as int,
        category: json['category'] as String? ?? '',
        narrator: json['narrator'] as String,
        source: json['source'] as String,
        arabic: json['arabic'] as String,
        fullArabic: json['full_arabic'] as String? ?? (json['arabic'] as String),
        translation: json['translation'] as String,
      );
}

class DailyHadithSelector {
  static List<DailyHadith>? _hadiths;

  static Future<DailyHadith> getDailyHadith() async {
    if (_hadiths == null) await _load();
    if (_hadiths == null || _hadiths!.isEmpty) {
      return DailyHadith(
        id: 0, number: 0, category: '',
        narrator: '', source: '',
        arabic: '', fullArabic: '', translation: '',
      );
    }
    final periodIndex = _sixHourPeriodIndex(DateTime.now());
    return _hadiths![periodIndex % _hadiths!.length];
  }

  static int _sixHourPeriodIndex(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final period = date.hour ~/ 6;
    return dayOfYear * 4 + period;
  }

  static Future<void> _load() async {
    final all = await HadithSearchIndex().getAll();
    _hadiths = all.map((e) => DailyHadith.fromJson(e)).toList();
  }
}
