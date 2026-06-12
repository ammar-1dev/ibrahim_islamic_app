import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/providers.dart';
import '../../../core/services/recent_activity_service.dart';
import '../../../core/utils/cities_data.dart';
import '../../../core/utils/prayer_calculator.dart';
import '../../../core/storage/local_storage.dart';

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
    ref.listen(prayerScheduleProvider, (prev, next) {
      if (prev == null && next.hasValue) {
        recordActivity(id: 'prayer-times', title: 'مواقيت الصلاة', subtitle: 'أوقات الصلاة اليوم', route: '/prayer-times', icon: '🕌');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city, color: AppColors.gold),
            tooltip: 'تغيير المدينة',
            onPressed: () => _showCityPicker(context, ref),
          ),
        ],
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
                onPressed: () {
                  _showCityPicker(context, ref);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
                child: const Text('اختر مدينة', style: TextStyle(color: AppColors.navy)),
              ),
            ],
          ),
        ),
        data: (schedule) => _PrayerTimesBody(schedule: schedule),
      ),
    );
  }

  void _showCityPicker(BuildContext context, WidgetRef ref) {
    final countries = citiesByCountry.keys.toList()..sort();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navyLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          String search = '';
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (ctx, scrollCtrl) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      const Text('اختر المدينة',
                        style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textOnDarkMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مدينة...',
                      hintStyle: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.gold, size: 20),
                      filled: true,
                      fillColor: AppColors.navy,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(8),
                    children: countries.where((c) =>
                      search.isEmpty || c.contains(search)
                    ).map((country) {
                      final cityList = citiesByCountry[country]!;
                      final filtered = search.isEmpty
                          ? cityList
                          : cityList.where((c) =>
                              c.name.contains(search)
                          ).toList();
                      if (filtered.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                            child: Text(country,
                              style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                          ...filtered.map((city) => ListTile(
                            dense: true,
                            title: Text(city.name,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18)),
                            subtitle: Text(city.country,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
                            trailing: const Icon(Icons.chevron_left, color: AppColors.goldMuted),
                            onTap: () async {
                              await ref.read(locationServiceProvider).setSelectedCity(city);
                              ref.invalidate(prayerScheduleProvider);
                              if (context.mounted) Navigator.pop(ctx);
                            },
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
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

class _NextPrayerBanner extends StatefulWidget {
  final PrayerScheduleModel schedule;
  const _NextPrayerBanner({required this.schedule});

  @override
  State<_NextPrayerBanner> createState() => _NextPrayerBannerState();
}

class _NextPrayerBannerState extends State<_NextPrayerBanner> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _update();
    });
  }

  void _update() {
    setState(() {
      _remaining = widget.schedule.timeUntilNextPrayer;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    if (d.isNegative) return '00:00:00';
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

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
          Text(widget.schedule.nextPrayerName,
            style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.xs),
          Text(_fmt(_remaining),
            style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 20, letterSpacing: 2)),
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
      bgColor = AppColors.success.withValues(alpha: 0.1);
      borderColor = AppColors.success.withValues(alpha: 0.4);
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
