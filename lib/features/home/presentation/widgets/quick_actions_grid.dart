import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = <_QuickAction>[
      _QuickAction(icon: Icons.menu_book, label: 'المصحف', route: '/mushaf', color: Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.access_time, label: 'مواقيت الصلاة', route: '/prayer-times', color: Color(0xFF2196F3)),
      _QuickAction(icon: Icons.explore, label: 'اتجاه القبلة', route: '/qibla', color: Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.volunteer_activism, label: 'الدعاء', route: '/dua', color: Color(0xFF9C27B0)),
      _QuickAction(icon: Icons.nightlight_round, label: 'الأذكار', route: '/azkar', color: Color(0xFFFF5722)),
      _QuickAction(icon: Icons.headphones, label: 'صوت القرآن', route: '/surah-audio', color: Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.search, label: 'بحث في القرآن', route: '/quran-search', color: Color(0xFF2196F3)),
      _QuickAction(icon: Icons.history_edu, label: 'الأحاديث', route: '/hadith', color: Color(0xFFFF9800)),
      _QuickAction(icon: Icons.bookmark, label: 'العلامات', route: '/bookmarks', color: Color(0xFF00BCD4)),
      _QuickAction(icon: Icons.library_books, label: 'المكتبة', route: '/books', color: Color(0xFFE91E63)),
      _QuickAction(icon: Icons.track_changes, label: 'الرحلة', route: '/journey', color: Color(0xFFFFC107)),
      _QuickAction(icon: Icons.people, label: 'أعلام المسلمين', route: '/companions', color: Color(0xFF3F51B5)),
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
              color: action.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: action.color.withValues(alpha: 0.3)),
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
