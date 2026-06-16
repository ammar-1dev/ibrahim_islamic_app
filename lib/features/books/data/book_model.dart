import 'dart:convert';
import 'package:flutter/services.dart';

class BookContent {
  final int bookId;
  final String? externalRoute;
  final List<BookChapter> chapters;

  const BookContent({
    required this.bookId,
    this.externalRoute,
    this.chapters = const [],
  });

  factory BookContent.fromJson(Map<String, dynamic> json) => BookContent(
        bookId: json['id'] as int,
        externalRoute: json['external_route'] as String?,
        chapters: (json['chapters'] as List?)
                ?.map((e) => BookChapter.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class BookChapter {
  final String title;
  final List<BookSection> sections;

  const BookChapter({required this.title, this.sections = const []});

  factory BookChapter.fromJson(Map<String, dynamic> json) => BookChapter(
        title: json['title'] as String,
        sections: (json['sections'] as List?)
                ?.map((e) => BookSection.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class BookSection {
  final String? title;
  final String text;

  const BookSection({this.title, required this.text});

  factory BookSection.fromJson(Map<String, dynamic> json) => BookSection(
        title: json['title'] as String?,
        text: json['text'] as String,
      );
}

class BookRepository {
  List<Map<String, dynamic>>? _booksMeta;
  Map<int, BookContent>? _contents;

  static const Map<int, String> _separateContentFiles = {
    6: 'assets/books/tafsir_ibn_kathir.json',
    7: 'assets/books/tafsir_tabari.json',
    23: 'assets/books/tafsir_saadi.json',
    27: 'assets/books/ibn_qayyim_27.json',
    28: 'assets/books/ibn_qayyim_28.json',
    29: 'assets/books/ibn_qayyim_29.json',
    30: 'assets/books/ibn_qayyim_30.json',
    31: 'assets/books/ibn_qayyim_31.json',
    32: 'assets/books/ibn_qayyim_32.json',
    33: 'assets/books/ibn_qayyim_33.json',
    34: 'assets/books/ibn_qayyim_34.json',
  };

  Future<List<Map<String, dynamic>>> loadBooksMeta() async {
    if (_booksMeta != null) return _booksMeta!;
    final json = await rootBundle.loadString('assets/books/islamic_books.json');
    final list = jsonDecode(json) as List;
    _booksMeta = list.cast<Map<String, dynamic>>();
    return _booksMeta!;
  }

  Future<Map<int, BookContent>> loadAllContent() async {
    if (_contents != null) return _contents!;
    final json = await rootBundle.loadString('assets/books/book_contents.json');
    final data = jsonDecode(json) as Map<String, dynamic>;
    _contents = data.map((key, value) =>
        MapEntry(int.parse(key), BookContent.fromJson(value as Map<String, dynamic>)));
    return _contents!;
  }

  Future<Map<String, dynamic>?> loadBookMeta(int bookId) async {
    final meta = await loadBooksMeta();
    for (final b in meta) {
      if (b['id'] as int == bookId) return b;
    }
    return null;
  }

  Future<BookContent?> loadContent(int bookId) async {
    final separateFile = _separateContentFiles[bookId];
    if (separateFile != null) {
      try {
        final json = await rootBundle.loadString(separateFile);
        return BookContent.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
    final all = await loadAllContent();
    return all[bookId];
  }
}
