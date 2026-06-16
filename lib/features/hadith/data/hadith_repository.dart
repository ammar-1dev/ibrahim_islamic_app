import 'dart:convert';
import 'package:flutter/services.dart';

class ChapterInfo {
  final int id;
  final int bookId;
  final String arabic;
  final String english;

  const ChapterInfo({
    required this.id,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  factory ChapterInfo.fromJson(Map<String, dynamic> json) => ChapterInfo(
        id: json['id'] as int,
        bookId: json['bookId'] as int? ?? 1,
        arabic: json['arabic'] as String? ?? '',
        english: json['english'] as String? ?? '',
      );
}

class HadithEntry {
  final int id;
  final int number;
  final int chapterId;
  final String category;
  final String narrator;
  final String source;
  final String arabic;
  final String fullArabic;
  final String translation;

  const HadithEntry({
    required this.id,
    required this.number,
    required this.chapterId,
    required this.category,
    required this.narrator,
    required this.source,
    required this.arabic,
    required this.fullArabic,
    required this.translation,
  });

  factory HadithEntry.fromJson(Map<String, dynamic> json) => HadithEntry(
        id: json['id'] as int,
        number: json['number'] as int,
        chapterId: json['chapterId'] as int? ?? 0,
        category: json['category'] as String? ?? '',
        narrator: json['narrator'] as String,
        source: json['source'] as String,
        arabic: json['arabic'] as String,
        fullArabic: json['full_arabic'] as String? ?? (json['arabic'] as String),
        translation: json['translation'] as String,
      );
}

class HadithCollection {
  final int id;
  final String name;
  final String nameEn;
  final String author;
  final int totalHadiths;
  final List<ChapterInfo> chapters;
  final List<HadithEntry> hadiths;

  const HadithCollection({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.author,
    required this.totalHadiths,
    required this.chapters,
    required this.hadiths,
  });

  factory HadithCollection.fromJson(Map<String, dynamic> json) => HadithCollection(
        id: json['id'] as int,
        name: json['name'] as String,
        nameEn: json['nameEn'] as String? ?? '',
        author: json['author'] as String? ?? '',
        totalHadiths: json['totalHadiths'] as int? ?? 0,
        chapters: (json['chapters'] as List)
            .map((e) => ChapterInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
        hadiths: (json['hadiths'] as List)
            .map((e) => HadithEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  List<HadithEntry> hadithsInChapter(int chapterId) =>
      hadiths.where((h) => h.chapterId == chapterId).toList();
}

class HadithCollectionInfo {
  final int id;
  final String name;
  final String nameEn;
  final String author;
  final int totalHadiths;
  final String assetPath;

  const HadithCollectionInfo({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.author,
    required this.totalHadiths,
    required this.assetPath,
  });
}

class HadithRepository {
  static final HadithRepository _instance = HadithRepository._();
  factory HadithRepository() => _instance;
  HadithRepository._();

  final Map<int, HadithCollection> _cache = {};

  static const collections = [
    HadithCollectionInfo(
      id: 1,
      name: 'صحيح البخاري',
      nameEn: 'Sahih al-Bukhari',
      author: 'الإمام محمد بن إسماعيل البخاري',
      totalHadiths: 7277,
      assetPath: 'assets/hadith/bukhari.json',
    ),
    HadithCollectionInfo(
      id: 2,
      name: 'صحيح مسلم',
      nameEn: 'Sahih Muslim',
      author: 'الإمام مسلم بن الحجاج النيسابوري',
      totalHadiths: 7459,
      assetPath: 'assets/hadith/muslim.json',
    ),
    HadithCollectionInfo(
      id: 3,
      name: 'الأربعون النووية',
      nameEn: "Al-Nawawi's 40 Hadith",
      author: 'الإمام النووي',
      totalHadiths: 42,
      assetPath: 'assets/hadith/hadith_40.json',
    ),
  ];

  static HadithCollectionInfo? getCollectionInfo(int id) {
    try {
      return collections.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<HadithCollection> load(int collectionId) async {
    if (_cache.containsKey(collectionId)) return _cache[collectionId]!;

    final info = getCollectionInfo(collectionId);
    if (info == null) throw Exception('Collection not found: $collectionId');

    final str = await rootBundle.loadString(info.assetPath);
    final data = json.decode(str) as Map<String, dynamic>;

    // handle legacy hadith_40.json format
    if (data.containsKey('hadiths') && !data.containsKey('chapters')) {
      final hadiths = (data['hadiths'] as List)
          .map((e) => HadithEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      final collection = HadithCollection(
        id: info.id,
        name: info.name,
        nameEn: info.nameEn,
        author: info.author,
        totalHadiths: hadiths.length,
        chapters: const [],
        hadiths: hadiths,
      );
      _cache[collectionId] = collection;
      return collection;
    }

    final collection = HadithCollection.fromJson(data);
    _cache[collectionId] = collection;
    return collection;
  }

  void clearCache() => _cache.clear();
}
