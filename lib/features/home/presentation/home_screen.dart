import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/providers.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/daily_hadith.dart';
import '../../../core/utils/daily_suggestion.dart';
import '../../../core/utils/date_utils.dart';
import 'widgets/prayer_countdown_card.dart';
import 'widgets/prayer_times_list.dart';
import 'widgets/daily_verse_card.dart';
import 'widgets/progress_tracker_row.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/recent_activity_section.dart';

final dailyVerseProvider = FutureProvider<DailyVerse>((ref) async {
  return DailyVerseSelector.getDailyVerse();
});

final dailyHadithProvider = FutureProvider<DailyHadith>((ref) async {
  return DailyHadithSelector.getDailyHadith();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _dayNames = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
  static const _hijriMonths = ['محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني', 'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'];
  static const _miladiMonths = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(prayerScheduleProvider);
    final verseAsync = ref.watch(dailyVerseProvider);
    final hadithAsync = ref.watch(dailyHadithProvider);
    final storage = LocalStorage();
    final now = DateTime.now();
    final today = HijriCalendar.now();
    final dayName = _dayNames[now.weekday - 1];
    final hijriMonth = _hijriMonths[today.hMonth - 1];
    final miladiMonth = _miladiMonths[now.month - 1];
    final suggestion = DailySuggestion.getForToday();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppDimensions.sm),

                  // ========== DATE SECTION ==========
                  GestureDetector(
                    onTap: () => context.push('/calendar'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg, horizontal: AppDimensions.lg),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A2C4E), Color(0xFF0F1C3A)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(color: AppColors.goldMuted),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.calendar_month, color: AppColors.gold, size: 28),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            dayName,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontFamily: 'Amiri',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.md),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: AppDimensions.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.navy,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                    border: Border.all(color: AppColors.goldMuted),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('التاريخ الهجري',
                                        style: TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 10)),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${today.hDay} $hijriMonth ${today.hYear} هـ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: AppColors.goldLight, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.sm),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm, horizontal: AppDimensions.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.navy,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                    border: Border.all(color: AppColors.goldMuted),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('التاريخ الميلادي',
                                        style: TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 10)),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${now.day} $miladiMonth ${now.year}م',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ========== PRAYER TIMES (تحت التاريخ مباشرة) ==========
                  scheduleAsync.when(
                    loading: () => const _LoadingCard(),
                    error: (_, __) => const _LoadingCard(),
                    data: (schedule) => Column(
                      children: [
                        PrayerCountdownCard(schedule: schedule),
                        const SizedBox(height: AppDimensions.sm),
                        PrayerTimesList(schedule: schedule),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ========== SUGGESTION OF THE DAY ==========
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.navyLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: AppColors.goldMuted),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(suggestion.icon ?? '🌟', style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.title,
                                style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                suggestion.text,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14, height: 1.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ========== AYAH OF THE DAY ==========
                  verseAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (verse) => DailyVerseCard(verse: verse),
                  ),
                  if (verseAsync.hasValue) const SizedBox(height: AppDimensions.md),

                  // ========== HADITH OF THE DAY ==========
                  hadithAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (hadith) => _HadithCard(hadith: hadith),
                  ),
                  if (hadithAsync.hasValue) const SizedBox(height: AppDimensions.md),

                  // ========== CONTINUE READING ==========
                  const ContinueReadingCard(),
                  const SizedBox(height: AppDimensions.md),

                  // ========== QUICK ACTIONS ==========
                  const QuickActionsGrid(),
                  const SizedBox(height: AppDimensions.md),

                  // ========== RECENTLY USED ==========
                  const RecentActivitySection(),
                  const SizedBox(height: AppDimensions.md),

                  // ========== PROGRESS ==========
                  ProgressTrackerRow(storage: storage),
                  const SizedBox(height: AppDimensions.lg),

                  // ========== MOOD SECTION ==========
                  _buildMoodSection(context),
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
    const moods = [
      ('😰', 'قلق'),
      ('🙏', 'شاكر'),
      ('😢', 'حزين'),
      ('😊', 'سعيد'),
      ('😴', 'متعب'),
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
                      Text(moods[i].$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(moods[i].$2,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.lg, AppDimensions.lg, AppDimensions.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Image.asset('assets/images/app_icon.png', height: 40, width: 40),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إبراهيم',
                style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700, height: 1.2)),
              Text('رفيقك الديني',
                style: TextStyle(color: AppColors.goldLight, fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, height: 1.2)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/surah-audio'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.headphones, color: AppColors.gold, size: 22),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          GestureDetector(
            onTap: () => context.push('/global-search'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.search, color: AppColors.gold, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _HadithCard extends StatelessWidget {
  final DailyHadith hadith;
  const _HadithCard({required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat, color: AppColors.gold, size: 16),
              const SizedBox(width: AppDimensions.xs),
              Text(
                'حديث اليوم — ${hadith.number}',
                style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              hadith.source,
              style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 10),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'عن ${hadith.narrator} رضي الله عنه قال:',
            style: const TextStyle(color: AppColors.goldLight, fontFamily: 'Amiri', fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '«${hadith.arabic}»',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, height: 2.0),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            height: 1,
            decoration: const BoxDecoration(color: AppColors.goldMuted),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            hadith.translation,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 13, height: 1.6),
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
