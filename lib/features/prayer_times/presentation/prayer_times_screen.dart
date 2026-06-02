import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/providers.dart';
import '../../../core/utils/prayer_calculator.dart';
import '../../../core/storage/local_storage.dart';

final prayerScheduleProvider = FutureProvider<PrayerScheduleModel>((ref) async {
  final location = await ref.read(locationServiceProvider).getCurrentLocation();
  return PrayerCalculator.calculate(latitude: location.latitude, longitude: location.longitude);
});

final prayerStatusProvider = StateNotifierProvider<PrayerStatusNotifier, Map<String, bool>>((ref) {
  return PrayerStatusNotifier();
});

class PrayerStatusNotifier extends StateNotifier<Map<String, bool>> {
  final _storage = LocalStorage();
  final List<String> _prayerKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  PrayerStatusNotifier() : super({}) {
    _load();
  }

  void _load() {
    for (final key in _prayerKeys) {
      state = {...state, key: _storage.getPrayerStatus(key)};
    }
  }

  void toggle(String key) {
    final current = _storage.getPrayerStatus(key);
    _storage.savePrayerStatus(key, !current);
    state = {...state, key: !current};
  }
}

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(prayerScheduleProvider);

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: scheduleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, color: AppColors.textOnDarkMuted, size: 48),
              const SizedBox(height: AppDimensions.md),
              const Text('تعذر تحديد موقعك', style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 20)),
              const SizedBox(height: AppDimensions.md),
              ElevatedButton(
                onPressed: () => ref.invalidate(prayerScheduleProvider),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
                child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.navy)),
              ),
            ],
          ),
        ),
        data: (schedule) => _PrayerTimesBody(schedule: schedule),
      ),
    );
  }
}

class _PrayerTimesBody extends ConsumerWidget {
  final PrayerScheduleModel schedule;
  const _PrayerTimesBody({required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statuses = ref.watch(prayerStatusProvider);

    final prayers = [
      _PrayerEntry('الفجر', 'fajr', schedule.fajr, Icons.brightness_3),
      _PrayerEntry('الشروق', 'sunrise', schedule.sunrise, Icons.wb_sunny),
      _PrayerEntry('الظهر', 'dhuhr', schedule.dhuhr, Icons.wb_sunny_outlined),
      _PrayerEntry('العصر', 'asr', schedule.asr, Icons.cloud),
      _PrayerEntry('المغرب', 'maghrib', schedule.maghrib, Icons.wb_twilight),
      _PrayerEntry('العشاء', 'isha', schedule.isha, Icons.nightlight_round),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      children: [
        _NextPrayerBanner(schedule: schedule),
        const SizedBox(height: AppDimensions.lg),
        ...prayers.map((p) => _PrayerCard(
          entry: p,
          isActive: schedule.nextPrayerName == p.name,
          isDone: statuses[p.key] ?? false,
          onTap: p.key != 'sunrise' ? () => ref.read(prayerStatusProvider.notifier).toggle(p.key) : null,
        )),
      ],
    );
  }
}

class _PrayerEntry {
  final String name;
  final String key;
  final DateTime time;
  final IconData icon;
  const _PrayerEntry(this.name, this.key, this.time, this.icon);
}

class _NextPrayerBanner extends StatelessWidget {
  final PrayerScheduleModel schedule;
  const _NextPrayerBanner({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyLight, Color(0xFF1E3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
      ),
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Column(
        children: [
          const Text('الصلاة القادمة',
            style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
          const SizedBox(height: AppDimensions.sm),
          Text(schedule.nextPrayerName,
            style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final _PrayerEntry entry;
  final bool isActive;
  final bool isDone;
  final VoidCallback? onTap;

  const _PrayerCard({required this.entry, required this.isActive, required this.isDone, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;

    if (isDone) {
      bgColor = AppColors.success.withOpacity(0.1);
      borderColor = AppColors.success.withOpacity(0.4);
    } else if (isActive) {
      bgColor = AppColors.goldMuted;
      borderColor = AppColors.gold;
    } else {
      bgColor = AppColors.navyLight;
      borderColor = AppColors.goldMuted;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(entry.icon, color: isActive ? AppColors.gold : AppColors.textOnDarkMuted, size: 22),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(entry.name,
                style: TextStyle(
                  color: isActive ? AppColors.gold : AppColors.textOnDark,
                  fontFamily: 'Amiri', fontSize: 20,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                )),
            ),
            Text(
              '${entry.time.hour.toString().padLeft(2, '0')}:${entry.time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: isActive ? AppColors.gold : AppColors.textOnDark,
                fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: const Text('الآن',
                  style: TextStyle(color: AppColors.navy, fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
            if (isDone) ...[
              const SizedBox(width: AppDimensions.sm),
              const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
