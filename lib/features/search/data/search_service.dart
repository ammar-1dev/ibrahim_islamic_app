import 'dart:convert';
import 'package:flutter/services.dart';
import '../../hadith/data/hadith_search_index.dart';

class SearchResult {
  final String type;
  final String title;
  final String subtitle;
  final String? route;
  final Map<String, dynamic>? extra;

  const SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    this.route,
    this.extra,
  });
}

class SearchService {
  List<Map<String, dynamic>>? _hadiths;
  List<Map<String, dynamic>>? _duas;
  List<Map<String, dynamic>>? _morningAzkar;
  List<Map<String, dynamic>>? _eveningAzkar;
  List<Map<String, dynamic>>? _books;
  List<Map<String, dynamic>>? _names;
  List<Map<String, dynamic>>? _figures;

  Future<void> _ensureHadith() async {
    if (_hadiths != null) return;
    _hadiths = await HadithSearchIndex().getAll();
  }

  Future<void> _ensureDuas() async {
    if (_duas != null) return;
    final str = await rootBundle.loadString('assets/dua/duas.json');
    final data = json.decode(str) as Map<String, dynamic>;
    _duas = (data['duas'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> _ensureAzkar() async {
    if (_morningAzkar != null) return;
    final str = await rootBundle.loadString('assets/azkar/azkar.json');
    final data = json.decode(str) as Map<String, dynamic>;
    _morningAzkar = (data['morning'] as List).cast<Map<String, dynamic>>();
    _eveningAzkar = (data['evening'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> _ensureBooks() async {
    if (_books != null) return;
    final str = await rootBundle.loadString('assets/books/islamic_books.json');
    _books = (json.decode(str) as List).cast<Map<String, dynamic>>();
  }

  Future<void> _ensureNames() async {
    if (_names != null) return;
    final str = await rootBundle.loadString('assets/names/99_names.json');
    _names = (json.decode(str) as List).cast<Map<String, dynamic>>();
  }

  Future<void> _ensureFigures() async {
    if (_figures != null) return;
    final str = await rootBundle.loadString('assets/companions/notable_muslims.json');
    final data = json.decode(str) as Map<String, dynamic>;
    _figures = (data['figures'] as List).cast<Map<String, dynamic>>();
  }

  List<SearchResult> _filter(List<Map<String, dynamic>> items, String query, String type,
      {String? titleKey, String? subtitleKey, String? contentKey, List<String>? extraFields}) {
    final q = query.toLowerCase();
    final results = <SearchResult>[];
    for (final item in items) {
      bool match = false;
      if (titleKey != null && (item[titleKey] as String? ?? '').toLowerCase().contains(q)) match = true;
      if (!match && subtitleKey != null && (item[subtitleKey] as String? ?? '').toLowerCase().contains(q)) match = true;
      if (!match && contentKey != null && (item[contentKey] as String? ?? '').toLowerCase().contains(q)) match = true;
      if (!match && extraFields != null) {
        for (final f in extraFields) {
          if ((item[f] as String? ?? '').toLowerCase().contains(q)) { match = true; break; }
        }
      }
      if (match) {
        results.add(SearchResult(
          type: type,
          title: titleKey != null ? (item[titleKey] as String? ?? '') : '',
          subtitle: subtitleKey != null ? (item[subtitleKey] as String? ?? '') : '',
          route: null,
          extra: item,
        ));
      }
    }
    return results;
  }

  Future<List<SearchResult>> search(String query, {int maxPerType = 8}) async {
    if (query.trim().isEmpty) return [];
    final q = query.trim();

    final futures = <Future<List<SearchResult>>>[];

    futures.add(_searchHadith(q, maxPerType));
    futures.add(_searchDuas(q, maxPerType));
    futures.add(_searchAzkar(q, maxPerType));
    futures.add(_searchBooks(q, maxPerType));
    futures.add(_searchNames(q, maxPerType));
    futures.add(_searchFigures(q, maxPerType));

    final results = await Future.wait(futures);
    return results.expand((r) => r).toList();
  }

  Future<List<SearchResult>> _searchHadith(String q, int max) async {
    await _ensureHadith();
    return _filter(_hadiths!, q, 'hadith',
        titleKey: 'arabic', subtitleKey: 'translation', contentKey: 'full_arabic',
        extraFields: ['narrator', 'source']);
  }

  Future<List<SearchResult>> _searchDuas(String q, int max) async {
    await _ensureDuas();
    return _filter(_duas!, q, 'dua',
        titleKey: 'arabic', subtitleKey: 'translation',
        extraFields: ['reference', 'category']);
  }

  Future<List<SearchResult>> _searchAzkar(String q, int max) async {
    await _ensureAzkar();
    final all = [..._morningAzkar!, ..._eveningAzkar!];
    return _filter(all, q, 'azkar',
        titleKey: 'arabic', subtitleKey: 'translation',
        extraFields: ['benefits']);
  }

  Future<List<SearchResult>> _searchBooks(String q, int max) async {
    await _ensureBooks();
    return _filter(_books!, q, 'book',
        titleKey: 'title', subtitleKey: 'author',
        extraFields: ['description', 'category']);
  }

  Future<List<SearchResult>> _searchNames(String q, int max) async {
    await _ensureNames();
    return _filter(_names!, q, 'name',
        titleKey: 'arabic', subtitleKey: 'meaning_ar',
        extraFields: ['transliteration', 'meaning_en']);
  }

  Future<List<SearchResult>> _searchFigures(String q, int max) async {
    await _ensureFigures();
    return _filter(_figures!, q, 'figure',
        titleKey: 'name', subtitleKey: 'title',
        extraFields: ['knownFor', 'profile', 'category']);
  }
}
