import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class NotableFigure {
  final int id;
  final String name;
  final String title;
  final String category;
  final String era;
  final List<String> achievements;
  final String knownFor;
  final String? deathPlace;
  final String profile;

  const NotableFigure({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    required this.era,
    required this.achievements,
    required this.knownFor,
    this.deathPlace,
    required this.profile,
  });

  factory NotableFigure.fromJson(Map<String, dynamic> json) => NotableFigure(
    id: json['id'] as int,
    name: json['name'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    era: json['era'] as String,
    achievements: (json['achievements'] as List).cast<String>(),
    knownFor: json['knownFor'] as String,
    deathPlace: json['deathPlace'] as String?,
    profile: json['profile'] as String,
  );
}

class CompanionsScreen extends StatefulWidget {
  const CompanionsScreen({super.key});

  @override
  State<CompanionsScreen> createState() => _CompanionsScreenState();
}

class _CompanionsScreenState extends State<CompanionsScreen> {
  List<NotableFigure> _all = [];
  List<NotableFigure> _filtered = [];
  List<String> _categories = [];
  String _selected = 'الكل';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final str = await rootBundle.loadString('assets/companions/notable_muslims.json');
    final data = json.decode(str) as Map<String, dynamic>;
    final all = (data['figures'] as List)
        .map((e) => NotableFigure.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _all = all;
      _categories = ['الكل', ...(data['categories'] as List).cast<String>()];
      _filtered = List.from(all);
      _loading = false;
    });
  }

  void _filter(String cat) {
    setState(() {
      _selected = cat;
      _filtered = cat == 'الكل' ? List.from(_all) : _all.where((f) => f.category == cat).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('أعلام المسلمين', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : Column(
              children: [
                _buildCategoryBar(),
                Expanded(child: _buildList()),
              ],
            ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final active = cat == _selected;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => _filter(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.gold : AppColors.navyLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? AppColors.gold : AppColors.goldMuted),
                ),
                child: Text(cat,
                  style: TextStyle(
                    color: active ? AppColors.navy : AppColors.textOnDark,
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return const Center(
        child: Text('لا يوجد أعلام في هذا التصنيف',
          style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
      itemCount: _filtered.length,
      itemBuilder: (context, i) => _FigureCard(figure: _filtered[i]),
    );
  }
}

class _FigureCard extends StatelessWidget {
  final NotableFigure figure;
  const _FigureCard({required this.figure});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(AppDimensions.lg, 0, AppDimensions.lg, AppDimensions.lg),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.gold,
        collapsedIconColor: AppColors.goldMuted,
        title: Row(
          children: [
            Expanded(
              child: Text(figure.name,
                style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(figure.title,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 13)),
            Row(
              children: [
                const Icon(Icons.date_range, color: AppColors.goldMuted, size: 12),
                const SizedBox(width: 4),
                Text(figure.era,
                  style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 11)),
              ],
            ),
          ],
        ),
        children: [
          const Divider(color: AppColors.goldMuted),
          const SizedBox(height: 4),
          if (figure.deathPlace != null)
            _infoRow(Icons.location_on, 'مكان الوفاة', figure.deathPlace!),
          _infoRow(Icons.star, 'أشتهر بـ', figure.knownFor),
          const SizedBox(height: 8),
          const Text('أهم الإنجازات:',
            style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ...figure.achievements.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColors.gold, fontSize: 14)),
                Expanded(
                  child: Text(a,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 13, height: 1.4)),
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(figure.profile,
              style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 12, height: 1.6)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldMuted, size: 14),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
