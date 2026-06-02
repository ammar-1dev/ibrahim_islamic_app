import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/providers.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/prayer_calculator.dart';
import '../../../core/storage/local_storage.dart';
import 'widgets/prayer_countdown_card.dart';
import 'widgets/daily_verse_card.dart';
import 'widgets/progress_tracker_row.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/smart_suggestion_card.dart';
import 'widgets/continue_reading_card.dart';

final prayerScheduleProvider = FutureProvider<PrayerScheduleModel>((ref) async {
  final location = await ref.read(locationServiceProvider).getCurrentLocation();
  return PrayerCalculator.calculate(latitude: location.latitude, longitude: location.longitude);
});

final dailyVerseProvider = FutureProvider<DailyVerse>((ref) async {
  return DailyVerseSelector.getDailyVerse();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(prayerScheduleProvider);
    final verseAsync = ref.watch(dailyVerseProvider);
    final storage = LocalStorage();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppDimensions.lg),
                  scheduleAsync.when(
                    loading: () => const _LoadingCard(),
                    error: (_, __) => const _LoadingCard(),
                    data: (schedule) => PrayerCountdownCard(schedule: schedule),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  const ContinueReadingCard(),
                  verseAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (verse) => DailyVerseCard(verse: verse),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  ProgressTrackerRow(storage: storage),
                  const SizedBox(height: AppDimensions.lg),
                  const QuickActionsGrid(),
                  const SizedBox(height: AppDimensions.lg),
                  _buildMoodSection(context),
                  const SizedBox(height: AppDimensions.lg),
                  const SmartSuggestionCard(),
                  const SizedBox(height: AppDimensions.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    final moods = [
      {'emoji': '😰', 'label': 'قلق'},
      {'emoji': '🙏', 'label': 'شاكر'},
      {'emoji': '😢', 'label': 'حزين'},
      {'emoji': '😊', 'label': 'سعيد'},
      {'emoji': '😴', 'label': 'متعب'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('كيف تشعر الآن؟',
          style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppDimensions.md),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: moods.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => context.push('/dua'),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(left: AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: AppColors.navyLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    border: Border.all(color: AppColors.goldMuted),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(moods[i]['emoji']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(moods[i]['label']!,
                        style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.lg, AppDimensions.lg, AppDimensions.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('إبراهيم',
            style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 28, fontWeight: FontWeight.w700)),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: AppColors.textOnDark),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: AppColors.textOnDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: const Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );
  }
}
