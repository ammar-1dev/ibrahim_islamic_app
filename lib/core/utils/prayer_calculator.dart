import 'package:adhan/adhan.dart';

class PrayerScheduleModel {
  final String nextPrayerName;
  final Duration timeUntilNextPrayer;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerScheduleModel({
    required this.nextPrayerName,
    required this.timeUntilNextPrayer,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class PrayerCalculator {
  static PrayerScheduleModel calculate({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final coords = Coordinates(latitude, longitude);
    
    // Fallback to manual parameters if CalculationMethod enum is problematic
    final params = CalculationParameters(fajrAngle: 18.0, ishaAngle: 17.0);
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents.from(date ?? DateTime.now());
    final prayerTimes = PrayerTimes(coords, dateComponents, params);

    final next = prayerTimes.nextPrayer();
    final nextName = _getPrayerName(next);
    final nextTime = prayerTimes.timeForPrayer(next) ?? DateTime.now();

    return PrayerScheduleModel(
      nextPrayerName: nextName,
      timeUntilNextPrayer: nextTime.difference(DateTime.now()),
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }

  static String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'الفجر';
      case Prayer.sunrise: return 'الشروق';
      case Prayer.dhuhr: return 'الظهر';
      case Prayer.asr: return 'العصر';
      case Prayer.maghrib: return 'المغرب';
      case Prayer.isha: return 'العشاء';
      case Prayer.none: return 'لا يوجد';
    }
  }
}
