import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/storage/local_storage.dart';

class ProgressTrackerRow extends StatelessWidget {
  final LocalStorage storage;
  const ProgressTrackerRow({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final prayerCount = storage.getTodayPrayerCount();
    final quranPage = storage.getQuranPage();

    return Row(
      children: [
        Expanded(
          child: _ProgressCard(
            icon: Icons.access_time,
            label: 'الصلوات اليوم',
            value: '$prayerCount/5',
            progress: prayerCount / 5,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _ProgressCard(
            icon: Icons.menu_book,
            label: 'صفحات القرآن',
            value: '$quranPage/604',
            progress: quranPage / 604,
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _ProgressCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppDimensions.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
