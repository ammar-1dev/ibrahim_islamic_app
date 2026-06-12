import 'package:adhan/adhan.dart';

class PrayerScheduleModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerScheduleModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  String get nextPrayerName {
    final now = DateTime.now();
    if (now.isBefore(fajr)) return 'الفجر';
    if (now.isBefore(sunrise)) return 'الشروق';
    if (now.isBefore(dhuhr)) return 'الظهر';
    if (now.isBefore(asr)) return 'العصر';
    if (now.isBefore(maghrib)) return 'المغرب';
    if (now.isBefore(isha)) return 'العشاء';
    return 'الفجر';
  }

  Duration get timeUntilNextPrayer {
    final now = DateTime.now();
    final prayers = [fajr, sunrise, dhuhr, asr, maghrib, isha];
    for (final p in prayers) {
      if (now.isBefore(p)) return p.difference(now);
    }
    return fajr.add(const Duration(days: 1)).difference(now);
  }
}

class PrayerCalculator {
  static PrayerScheduleModel calculate({
    required double latitude,
    required double longitude,
    DateTime? date,
    double fajrAngle = 18.0,
    double ishaAngle = 17.0,
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = CalculationParameters(fajrAngle: fajrAngle, ishaAngle: ishaAngle);
    params.madhab = Madhab.shafi;
    final dateComponents = DateComponents.from(date ?? DateTime.now());
    final prayerTimes = PrayerTimes(coords, dateComponents, params);

    return PrayerScheduleModel(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }

  static String getPrayerName(Prayer prayer) {
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
