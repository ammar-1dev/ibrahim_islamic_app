import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class NameModel {
  final int id;
  final String arabic;
  final String transliteration;
  final String meaningAr;
  final String meaningEn;

  const NameModel({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaningAr,
    required this.meaningEn,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) => NameModel(
        id: json['id'] as int,
        arabic: json['arabic'] as String,
        transliteration: json['transliteration'] as String,
        meaningAr: json['meaning_ar'] as String,
        meaningEn: json['meaning_en'] as String,
      );
}

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  List<NameModel> _names = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final str = await rootBundle.loadString('assets/names/99_names.json');
    final data = json.decode(str) as List;
    setState(() {
      _names = data.map((e) => NameModel.fromJson(e as Map<String, dynamic>)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('أسماء الله الحسنى'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(AppDimensions.lg),
                    padding: const EdgeInsets.all(AppDimensions.xl),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navyLight, Color(0xFF1A2C4E)],
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: AppColors.goldMuted),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'وَلِلَّهِ الْأَسْمَاءُ الْحُسْنَى فَادْعُوهُ بِهَا',
                          style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'من أحصاها دخل الجنة',
                          style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: AppDimensions.md,
                      mainAxisSpacing: AppDimensions.md,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final name = _names[index];
                        return GestureDetector(
                          onTap: () => _showNameDetail(context, name),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.navyLight,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                              border: Border.all(color: AppColors.goldMuted),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name.arabic,
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontFamily: 'Amiri',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    name.transliteration,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.textOnDarkMuted,
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${name.id}',
                                  style: const TextStyle(
                                    color: AppColors.goldMuted,
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _names.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
              ],
            ),
    );
  }

  void _showNameDetail(BuildContext context, NameModel name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppDimensions.xl),
            Text(name.arabic, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimensions.sm),
            Text(name.transliteration, style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 14)),
            const SizedBox(height: AppDimensions.lg),
            Text(name.meaningAr, style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18, height: 1.6)),
            const SizedBox(height: AppDimensions.sm),
            Text(name.meaningEn, style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 13, fontStyle: FontStyle.italic)),
            const SizedBox(height: AppDimensions.lg),
            Text('${name.id} من 99', style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 12)),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}
