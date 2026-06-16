import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/hadith_repository.dart';

class HadithCollectionsScreen extends StatelessWidget {
  const HadithCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('موسوعة الأحاديث'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.lg),
        itemCount: HadithRepository.collections.length,
        itemBuilder: (context, i) => _CollectionCard(
          collection: HadithRepository.collections[i],
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final HadithCollectionInfo collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hadith/${collection.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.lg),
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.goldMuted),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.goldMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: const Icon(Icons.auto_stories, color: AppColors.gold, size: 28),
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.name,
                    style: const TextStyle(
                      color: AppColors.textOnDark,
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    collection.author,
                    style: const TextStyle(
                      color: AppColors.textOnDarkMuted,
                      fontFamily: 'Inter',
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${collection.totalHadiths} حديث',
                    style: const TextStyle(
                      color: AppColors.goldMuted,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.goldMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
