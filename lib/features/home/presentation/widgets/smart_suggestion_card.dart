import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';

class SmartSuggestionCard extends StatelessWidget {
  const SmartSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestion = _getSuggestion();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.goldMuted,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(
              child: Text(
                suggestion.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اقتراح الآن',
                  style: TextStyle(
                    color: AppColors.textOnDarkMuted,
                    fontFamily: 'Inter',
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  suggestion.text,
                  style: const TextStyle(
                    color: AppColors.textOnDark,
                    fontFamily: 'Amiri',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.gold, size: 16),
        ],
      ),
    );
  }

  _Suggestion _getSuggestion() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 6) {
      return _Suggestion('🌙', 'صلِّ ركعتي الفجر');
    } else if (hour >= 6 && hour < 9) {
      return _Suggestion('🌅', 'أذكار الصباح');
    } else if (hour >= 12 && hour < 13) {
      return _Suggestion('☀️', 'صلاة الظهر في وقتها');
    } else if (hour >= 15 && hour < 16) {
      return _Suggestion('📖', 'اقرأ ورد القرآن');
    } else if (hour >= 18 && hour < 20) {
      return _Suggestion('🌇', 'أذكار المساء');
    } else if (hour >= 20) {
      return _Suggestion('⭐', 'قيام الليل');
    }
    return _Suggestion('🤲', 'تذكّر الله دائماً');
  }
}

class _Suggestion {
  final String emoji;
  final String text;
  const _Suggestion(this.emoji, this.text);
}
