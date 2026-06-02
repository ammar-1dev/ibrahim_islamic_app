import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class HadithModel {
  final int id;
  final String arabic;
  final String translation;
  final String narrator;
  final String source;
  final int number;

  const HadithModel({
    required this.id,
    required this.arabic,
    required this.translation,
    required this.narrator,
    required this.source,
    required this.number,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) => HadithModel(
        id: json['id'] as int,
        arabic: json['arabic'] as String,
        translation: json['translation'] as String,
        narrator: json['narrator'] as String,
        source: json['source'] as String,
        number: json['number'] as int,
      );
}

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  List<HadithModel> _hadiths = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final str = await rootBundle.loadString('assets/hadith/hadith_40.json');
    final data = json.decode(str) as Map<String, dynamic>;
    setState(() {
      _hadiths = (data['hadiths'] as List)
          .map((e) => HadithModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الأربعون النووية'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.lg),
              itemCount: _hadiths.length,
              itemBuilder: (context, i) => _HadithCard(hadith: _hadiths[i]),
            ),
    );
  }
}

class _HadithCard extends StatelessWidget {
  final HadithModel hadith;
  const _HadithCard({required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.lg),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldMuted,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  'الحديث ${hadith.id}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                hadith.source,
                style: const TextStyle(
                  color: AppColors.textOnDarkMuted,
                  fontFamily: 'Inter',
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            hadith.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 18,
              height: 2.0,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          const Divider(color: AppColors.goldMuted),
          const SizedBox(height: AppDimensions.sm),
          Text(
            hadith.translation,
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'عن ${hadith.narrator}',
            style: const TextStyle(
              color: AppColors.goldLight,
              fontFamily: 'Amiri',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
