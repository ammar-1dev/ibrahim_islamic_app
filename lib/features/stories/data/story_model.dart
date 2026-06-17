import 'package:flutter/material.dart';

class StoryCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const StoryCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

const storyCategories = [
  StoryCategory(id: 'all', name: 'الكل', icon: Icons.explore, color: Color(0xFF9C27B0)),
  StoryCategory(id: 'battles', name: 'معارك وفتوحات', icon: Icons.shield, color: Color(0xFFE53935)),
  StoryCategory(id: 'prophets', name: 'قصص الأنبياء', icon: Icons.mosque, color: Color(0xFF4CAF50)),
  StoryCategory(id: 'companions', name: 'الصحابة', icon: Icons.people, color: Color(0xFF2196F3)),
  StoryCategory(id: 'quranic', name: 'قصص قرآنية', icon: Icons.menu_book, color: Color(0xFFFF9800)),
];

class StoryInfo {
  final int id;
  final String title;
  final String subtitle;
  final String category;
  final String era;
  final String summary;
  final IconData icon;

  const StoryInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.era,
    required this.summary,
    required this.icon,
  });

  factory StoryInfo.fromJson(Map<String, dynamic> json) => StoryInfo(
        id: json['id'] as int,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        category: json['category'] as String? ?? 'battles',
        era: json['era'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        icon: Icons.auto_stories,
      );
}

class StorySection {
  final String title;
  final String text;

  const StorySection({required this.title, required this.text});

  factory StorySection.fromJson(Map<String, dynamic> json) => StorySection(
        title: json['title'] as String? ?? '',
        text: json['text'] as String? ?? '',
      );
}

class StoryContent {
  final int id;
  final String title;
  final String subtitle;
  final String category;
  final String era;
  final String summary;
  final List<StorySection> sections;

  const StoryContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.era,
    required this.summary,
    this.sections = const [],
  });

  factory StoryContent.fromJson(Map<String, dynamic> json) => StoryContent(
        id: json['id'] as int,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        category: json['category'] as String? ?? 'battles',
        era: json['era'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        sections: (json['sections'] as List?)?.map((e) => StorySection.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );
}
