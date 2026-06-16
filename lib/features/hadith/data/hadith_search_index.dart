import 'dart:convert';
import 'package:flutter/services.dart';
import 'hadith_repository.dart';

class HadithSearchIndex {
  static final HadithSearchIndex _instance = HadithSearchIndex._();
  factory HadithSearchIndex() => _instance;
  HadithSearchIndex._();

  List<Map<String, dynamic>>? _allHadiths;
  bool _loaded = false;

  Future<List<Map<String, dynamic>>> getAll() async {
    if (_loaded) return _allHadiths!;
    return _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    _allHadiths = [];
    for (final info in HadithRepository.collections) {
      try {
        final str = await rootBundle.loadString(info.assetPath);
        final data = json.decode(str) as Map<String, dynamic>;

        if (data.containsKey('hadiths') && data.containsKey('chapters')) {
          for (final h in data['hadiths'] as List) {
            final m = h as Map<String, dynamic>;
            m['collectionName'] = info.name;
            _allHadiths!.add(m);
          }
        } else if (data.containsKey('hadiths')) {
          for (final h in data['hadiths'] as List) {
            final m = h as Map<String, dynamic>;
            m['collectionName'] = info.name;
            _allHadiths!.add(m);
          }
        }
      } catch (_) {}
    }
    _loaded = true;
    return _allHadiths!;
  }

  void clear() {
    _allHadiths = null;
    _loaded = false;
  }
}
