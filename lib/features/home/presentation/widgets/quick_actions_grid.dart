import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../generated/app_localizations.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final actions = <_QuickAction>[
      _QuickAction(icon: Icons.menu_book, label: l.quickMushaf, route: '/mushaf', color: const Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.history_edu, label: l.quickHadith, route: '/hadith', color: const Color(0xFFFF9800)),
      _QuickAction(icon: Icons.access_time, label: l.quickPrayerTimes, route: '/prayer-times', color: const Color(0xFF2196F3)),
      _QuickAction(icon: Icons.explore, label: l.quickQibla, route: '/qibla', color: const Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.mosque, label: l.quickMosqueMap, route: '/mosque-map', color: const Color(0xFF009688)),
      _QuickAction(icon: Icons.volunteer_activism, label: l.quickDua, route: '/dua', color: const Color(0xFF9C27B0)),
      _QuickAction(icon: Icons.nightlight_round, label: l.quickMorningAzkar, route: '/morning-adhkar', color: const Color(0xFFFF5722)),
      _QuickAction(icon: Icons.wb_sunny, label: l.quickEveningAzkar, route: '/evening-adhkar', color: const Color(0xFFFF9800)),
      _QuickAction(icon: Icons.bookmark_border, label: l.quickMiscAzkar, route: '/occasions-adhkar', color: const Color(0xFF9C27B0)),
      _QuickAction(icon: Icons.headphones, label: l.quickQuranAudio, route: '/surah-audio', color: const Color(0xFF4CAF50)),
      _QuickAction(icon: Icons.search, label: l.quickQuranSearch, route: '/quran-search', color: const Color(0xFF2196F3)),
      _QuickAction(icon: Icons.bookmark, label: l.quickBookmarks, route: '/bookmarks', color: const Color(0xFF00BCD4)),
      _QuickAction(icon: Icons.library_books, label: l.quickLibrary, route: '/books', color: const Color(0xFFE91E63)),
      _QuickAction(icon: Icons.timeline, label: l.quickSeerah, route: '/seerah', color: const Color(0xFF2196F3)),
      _QuickAction(icon: Icons.mosque, label: l.quickFiqh, route: '/fiqh', color: const Color(0xFF795548)),
      _QuickAction(icon: Icons.track_changes, label: l.quickJourney, route: '/journey', color: const Color(0xFFFFC107)),
      _QuickAction(icon: Icons.people, label: l.quickCompanions, route: '/companions', color: const Color(0xFF3F51B5)),
      _QuickAction(icon: Icons.palette, label: l.quickTajweed, route: '/tajweed-reader', color: const Color(0xFFE91E63)),
      _QuickAction(icon: Icons.female, label: l.quickWomensSection, route: '/womens-section', color: const Color(0xFFEC407A)),
      _QuickAction(icon: Icons.healing, label: l.quickRuqyah, route: '/ruqyah', color: const Color(0xFF795548)),
      _QuickAction(icon: Icons.people_outline, label: l.quickSocial, route: '/social', color: const Color(0xFF00BCD4)),
      _QuickAction(icon: Icons.fingerprint, label: l.quickNamesOfAllah, route: '/names', color: const Color(0xFF009688)),
      _QuickAction(icon: Icons.auto_stories, label: l.quickAsbabNuzul, route: '/asbab-book', color: const Color(0xFFFF9800)),
      _QuickAction(icon: Icons.history_edu, label: l.quickStories, route: '/stories', color: const Color(0xFFE53935)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.quickAccessTitle,
          style: const TextStyle(
            color: AppColors.textOnDark,
            fontFamily: 'Amiri',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppDimensions.sm,
          crossAxisSpacing: AppDimensions.sm,
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: action.color.withValues(alpha: 0.3)),
            ),
            child: Icon(action.icon, color: action.color, size: 22),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            action.label,
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontFamily: 'Amiri',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
