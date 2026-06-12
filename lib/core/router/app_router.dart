import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../widgets/ibrahim_scaffold.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/quran/presentation/quran_screen.dart';
import '../../features/quran/presentation/khatma_planner_screen.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/ai_assistant/presentation/ai_chat_screen.dart';
import '../../features/prayer_times/presentation/prayer_times_screen.dart';
import '../../features/qibla/presentation/qibla_screen.dart';
import '../../features/azkar/presentation/azkar_screen.dart';
import '../../features/azkar/presentation/tasbeeh_screen.dart';
import '../../features/dua/presentation/dua_screen.dart';
import '../../features/hadith/presentation/hadith_screen.dart';
import '../../features/spiritual_journey/presentation/journey_screen.dart';
import '../../features/family_hub/presentation/family_screen.dart';
import '../../features/zakat/presentation/zakat_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/names_of_allah/presentation/names_screen.dart';
import '../../features/hajj/presentation/hajj_screen.dart';
import '../../features/quran/presentation/quran_mushaf_screen.dart';
import '../../features/quran/presentation/surah_audio_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/recording/presentation/recording_screen.dart';
import '../../features/notification_settings/presentation/notification_settings_screen.dart';
import '../../features/search/presentation/global_search_screen.dart';
import '../../features/mosque_map/presentation/mosque_map_screen.dart';
import '../../features/sadaqah/presentation/sadaqah_screen.dart';
import '../../features/wird/presentation/wird_screen.dart';
import '../../features/books/presentation/islamic_books_screen.dart';
import '../../features/books/presentation/book_reader_screen.dart';
import '../../features/companions/presentation/companions_screen.dart';
import '../../features/quran/presentation/quran_search_screen.dart';
import '../../features/quran/presentation/bookmarks_screen.dart';
import '../../features/quran/presentation/surah_reader_screen.dart';
import '../../data/quran/surah_meta.dart';
import '../di/onboarding_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final onboardingDone = ref.watch(onboardingDoneProvider);
  return GoRouter(
    initialLocation: onboardingDone ? '/' : '/onboarding',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return IbrahimScaffold(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/quran', builder: (context, state) => const QuranScreen()),
          GoRoute(path: '/explore', builder: (context, state) => const ExploreScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(path: '/family', builder: (context, state) => const FamilyHubScreen()),
        ],
      ),
      GoRoute(path: '/ai-assistant', builder: (context, state) => const AiChatScreen()),
      GoRoute(path: '/prayer-times', builder: (context, state) => const PrayerTimesScreen()),
      GoRoute(path: '/qibla', builder: (context, state) => const QiblaScreen()),
      GoRoute(path: '/azkar', builder: (context, state) => const AzkarScreen()),
      GoRoute(path: '/tasbeeh', builder: (context, state) => const TasbeehScreen()),
      GoRoute(path: '/dua', builder: (context, state) => const DuaScreen()),
      GoRoute(path: '/hadith', builder: (context, state) => const HadithScreen()),
      GoRoute(path: '/journey', builder: (context, state) => const SpiritualJourneyScreen()),
      GoRoute(path: '/khatma', builder: (context, state) => const KhatmaPlannerScreen()),
      GoRoute(path: '/zakat', builder: (context, state) => const ZakatScreen()),
      GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
      GoRoute(path: '/names', builder: (context, state) => const NamesOfAllahScreen()),
      GoRoute(path: '/hajj', builder: (context, state) => const HajjScreen()),
      GoRoute(path: '/mushaf', builder: (context, state) => const QuranMushafScreen()),
      GoRoute(path: '/surah-audio', builder: (context, state) => const SurahAudioScreen()),
      GoRoute(path: '/mosque-map', builder: (context, state) => const MosqueMapScreen()),
      GoRoute(path: '/sadaqah', builder: (context, state) => const SadaqahScreen()),
      GoRoute(path: '/wird', builder: (context, state) => const WirdScreen()),
      GoRoute(path: '/quran-search', builder: (context, state) => const QuranSearchScreen()),
      GoRoute(path: '/bookmarks', builder: (context, state) => const BookmarksScreen()),
      GoRoute(path: '/books', builder: (context, state) => const IslamicBooksScreen()),
      GoRoute(
        path: '/book-reader/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return BookReaderScreen(bookId: id);
        },
      ),
      GoRoute(
        path: '/surah-reader',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final sn = extra?['surah'] as int? ?? 1;
          final readerSurah = SurahMeta(
            number: sn,
            nameArabic: extra?['surahName'] as String? ?? 'سورة $sn',
            nameEnglish: '',
            nameTransliteration: '',
            ayahs: 0,
            revelationType: '',
            startPage: 0,
          );
          return SurahReaderScreen(surah: readerSurah, initialAyah: extra?['ayah'] as int?);
        },
      ),
      GoRoute(path: '/companions', builder: (context, state) => const CompanionsScreen()),
      GoRoute(path: '/global-search', builder: (context, state) => const GlobalSearchScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/notification-settings', builder: (context, state) => const NotificationSettingsScreen()),
      GoRoute(path: '/recording', builder: (context, state) => const RecordingScreen()),
    ],
  );
}
