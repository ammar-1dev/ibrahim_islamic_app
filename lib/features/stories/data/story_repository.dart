import 'dart:convert';
import 'package:flutter/services.dart';
import 'story_model.dart';

class StoryRepository {
  List<StoryInfo>? _storiesMeta;
  Map<int, StoryContent>? _contents;

  Future<List<StoryInfo>> loadStoriesMeta() async {
    if (_storiesMeta != null) return _storiesMeta!;
    final json = await rootBundle.loadString('assets/stories/stories_meta.json');
    final list = jsonDecode(json) as List;
    _storiesMeta = list.map((e) => StoryInfo.fromJson(e as Map<String, dynamic>)).toList();
    return _storiesMeta!;
  }

  Future<Map<int, StoryContent>> loadAllContent() async {
    if (_contents != null) return _contents!;
    final json = await rootBundle.loadString('assets/stories/stories_content.json');
    final data = jsonDecode(json) as Map<String, dynamic>;
    _contents = data.map((key, value) =>
        MapEntry(int.parse(key), StoryContent.fromJson(value as Map<String, dynamic>)));
    return _contents!;
  }

  Future<StoryContent?> loadStoryContent(int id) async {
    final all = await loadAllContent();
    return all[id];
  }
}
