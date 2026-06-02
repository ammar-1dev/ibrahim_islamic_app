import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/utils/date_utils.dart';

class DailyVerseCard extends StatelessWidget {
  final DailyVerse verse;
  const DailyVerseCard({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted, width: 1),
      ),
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_stories, color: AppColors.gold, size: 16),
              const SizedBox(width: AppDimensions.xs),
              const Text(
                'آية اليوم',
                style: TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            verse.arabic,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 22,
              height: 2.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            height: 1,
            decoration: const BoxDecoration(color: AppColors.goldMuted),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            verse.translation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '— سورة ${verse.surah}، الآية ${verse.ayah}',
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
