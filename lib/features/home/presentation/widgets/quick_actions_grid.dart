import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(icon: Icons.menu_book, label: 'المصحف', route: '/mushaf', color: const Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.list_alt, label: 'السور', route: '/quran', color: AppColors.gold),
      _QuickAction(icon: Icons.volunteer_activism, label: 'الدعاء', route: '/dua', color: const Color(0xFF9C27B0)),
      _QuickAction(icon: Icons.explore, label: 'القبلة', route: '/qibla', color: const Color(0xFF2196F3)),
      _QuickAction(icon: Icons.history_edu, label: 'الأحاديث', route: '/hadith', color: const Color(0xFFFF9800)),
      _QuickAction(icon: Icons.calculate, label: 'الزكاة', route: '/zakat', color: const Color(0xFF00BCD4)),
      _QuickAction(icon: Icons.calendar_month, label: 'التقويم', route: '/calendar', color: const Color(0xFFE91E63)),
      _QuickAction(icon: Icons.track_changes, label: 'الرحلة', route: '/journey', color: const Color(0xFFFFC107)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوصول السريع',
          style: TextStyle(
            color: AppColors.textOnDark,
            fontFamily: 'Amiri',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimensions.md,
          crossAxisSpacing: AppDimensions.md,
          children: actions.map((a) => _ActionItem(action: a)).toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.route, required this.color});
}

class _ActionItem extends StatelessWidget {
  final _QuickAction action;
  const _ActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(action.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: action.color.withOpacity(0.3)),
            ),
            child: Icon(action.icon, color: action.color, size: 26),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            action.label,
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontFamily: 'Amiri',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
