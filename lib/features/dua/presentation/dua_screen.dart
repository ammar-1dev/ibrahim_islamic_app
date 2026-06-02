import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

enum UserMood { anxious, grateful, sad, happy, fearful, sick, tired, hopeful }

class Dua {
  final int id;
  final String arabic;
  final String translation;
  final String reference;
  final String category;
  final List<String> tags;

  const Dua({
    required this.id,
    required this.arabic,
    required this.translation,
    required this.reference,
    required this.category,
    required this.tags,
  });

  factory Dua.fromJson(Map<String, dynamic> json) => Dua(
        id: json['id'] as int,
        arabic: json['arabic'] as String,
        translation: json['translation'] as String,
        reference: json['reference'] as String,
        category: json['category'] as String,
        tags: (json['tags'] as List).cast<String>(),
      );
}

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  List<Dua> _allDuas = [];
  List<Dua> _filtered = [];
  UserMood? _selectedMood;
  bool _loading = true;

  final Map<UserMood, Map<String, dynamic>> _moodData = {
    UserMood.anxious:  {'emoji': '😰', 'label': 'قلق', 'tags': ['anxiety', 'worry', 'stress']},
    UserMood.grateful: {'emoji': '🙏', 'label': 'شاكر', 'tags': ['gratitude', 'shukr', 'praise']},
    UserMood.sad:      {'emoji': '😢', 'label': 'حزين', 'tags': ['sadness', 'grief', 'loss']},
    UserMood.happy:    {'emoji': '😊', 'label': 'سعيد', 'tags': ['grateful', 'happy', 'praise']},
    UserMood.fearful:  {'emoji': '😨', 'label': 'خائف', 'tags': ['fearful', 'anxiety', 'ruqyah']},
    UserMood.sick:     {'emoji': '🤒', 'label': 'مريض', 'tags': ['sick', 'illness', 'healing', 'ruqyah']},
    UserMood.tired:    {'emoji': '😴', 'label': 'متعب', 'tags': ['tired', 'anxiety', 'stress']},
    UserMood.hopeful:  {'emoji': '⭐', 'label': 'متفائل', 'tags': ['hopeful', 'general', 'gratitude']},
  };

  @override
  void initState() {
    super.initState();
    _loadDuas();
  }

  Future<void> _loadDuas() async {
    final str = await rootBundle.loadString('assets/dua/duas.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final duas = (data['duas'] as List).map((e) => Dua.fromJson(e as Map<String, dynamic>)).toList();
    setState(() {
      _allDuas = duas;
      _filtered = duas;
      _loading = false;
    });
  }

  void _selectMood(UserMood mood) {
    setState(() {
      if (_selectedMood == mood) {
        _selectedMood = null;
        _filtered = _allDuas;
      } else {
        _selectedMood = mood;
        final tags = (_moodData[mood]!['tags'] as List).cast<String>();
        _filtered = _allDuas.where((d) => d.tags.any(tags.contains)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الأدعية'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildMoodEngine()),
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _DuaCard(dua: _filtered[index]),
                      childCount: _filtered.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMoodEngine() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'محرك الدعاء الذكي',
            style: TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          const Text(
            'كيف تشعر الآن؟',
            style: TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: _moodData.entries.map((e) {
              final selected = _selectedMood == e.key;
              return GestureDetector(
                onTap: () => _selectMood(e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold : AppColors.navyLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(
                        color: selected ? AppColors.gold : AppColors.goldMuted),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(e.value['emoji'] as String, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        e.value['label'] as String,
                        style: TextStyle(
                          color: selected ? AppColors.navy : AppColors.textOnDark,
                          fontFamily: 'Amiri',
                          fontSize: 15,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedMood != null) ...[
            const SizedBox(height: AppDimensions.md),
            Text(
              '${_filtered.length} دعاء مناسب',
              style: const TextStyle(
                color: AppColors.goldLight,
                fontFamily: 'Inter',
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final Dua dua;
  const _DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dua.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 19,
              height: 2.0,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            dua.translation,
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dua.reference,
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontFamily: 'Amiri',
                  fontSize: 13,
                ),
              ),
              Icon(Icons.bookmark_border, color: AppColors.textOnDarkMuted, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
