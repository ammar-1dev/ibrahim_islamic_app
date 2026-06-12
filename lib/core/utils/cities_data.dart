class CityInfo {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final double fajrAngle;
  final double ishaAngle;

  const CityInfo({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.fajrAngle = 18.0,
    this.ishaAngle = 17.0,
  });
}

final List<CityInfo> cities = [
  // مصر
  const CityInfo(name: 'القاهرة', country: 'مصر', latitude: 30.0444, longitude: 31.2357, fajrAngle: 19.5, ishaAngle: 17.5),
  const CityInfo(name: 'الإسكندرية', country: 'مصر', latitude: 31.2001, longitude: 29.9187, fajrAngle: 19.5, ishaAngle: 17.5),
  const CityInfo(name: 'الجيزة', country: 'مصر', latitude: 30.0131, longitude: 31.2089, fajrAngle: 19.5, ishaAngle: 17.5),
  const CityInfo(name: 'أسوان', country: 'مصر', latitude: 24.0889, longitude: 32.8998, fajrAngle: 19.5, ishaAngle: 17.5),
  const CityInfo(name: 'الأقصر', country: 'مصر', latitude: 25.6872, longitude: 32.6396, fajrAngle: 19.5, ishaAngle: 17.5),

  // السعودية
  const CityInfo(name: 'مكة المكرمة', country: 'السعودية', latitude: 21.4225, longitude: 39.8262),
  const CityInfo(name: 'المدينة المنورة', country: 'السعودية', latitude: 24.4672, longitude: 39.6112),
  const CityInfo(name: 'الرياض', country: 'السعودية', latitude: 24.7136, longitude: 46.6753),
  const CityInfo(name: 'جدة', country: 'السعودية', latitude: 21.4858, longitude: 39.1925),
  const CityInfo(name: 'الدمام', country: 'السعودية', latitude: 26.4207, longitude: 50.0888),

  // الإمارات
  const CityInfo(name: 'أبو ظبي', country: 'الإمارات', latitude: 24.4539, longitude: 54.3773),
  const CityInfo(name: 'دبي', country: 'الإمارات', latitude: 25.2048, longitude: 55.2708),
  const CityInfo(name: 'الشارقة', country: 'الإمارات', latitude: 25.3463, longitude: 55.4209),

  // الكويت
  const CityInfo(name: 'الكويت', country: 'الكويت', latitude: 29.3759, longitude: 47.9774),
  const CityInfo(name: 'مدينة الكويت', country: 'الكويت', latitude: 29.3697, longitude: 47.9783),

  // قطر
  const CityInfo(name: 'الدوحة', country: 'قطر', latitude: 25.2854, longitude: 51.5310),

  // البحرين
  const CityInfo(name: 'المنامة', country: 'البحرين', latitude: 26.2285, longitude: 50.5860),

  // عمان
  const CityInfo(name: 'مسقط', country: 'عمان', latitude: 23.5880, longitude: 58.3829),

  // الأردن
  const CityInfo(name: 'عمان', country: 'الأردن', latitude: 31.9454, longitude: 35.9284, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'إربد', country: 'الأردن', latitude: 32.5556, longitude: 35.8499, fajrAngle: 18.0, ishaAngle: 17.0),

  // فلسطين
  const CityInfo(name: 'القدس', country: 'فلسطين', latitude: 31.7683, longitude: 35.2137, fajrAngle: 17.5, ishaAngle: 16.0),
  const CityInfo(name: 'غزة', country: 'فلسطين', latitude: 31.5017, longitude: 34.4668, fajrAngle: 17.5, ishaAngle: 16.0),
  const CityInfo(name: 'رام الله', country: 'فلسطين', latitude: 31.9038, longitude: 35.2034, fajrAngle: 17.5, ishaAngle: 16.0),

  // سوريا
  const CityInfo(name: 'دمشق', country: 'سوريا', latitude: 33.5138, longitude: 36.2765, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'حلب', country: 'سوريا', latitude: 36.2021, longitude: 37.1403, fajrAngle: 18.0, ishaAngle: 17.0),

  // العراق
  const CityInfo(name: 'بغداد', country: 'العراق', latitude: 33.3152, longitude: 44.3661, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'النجف', country: 'العراق', latitude: 31.9968, longitude: 44.3194, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'كربلاء', country: 'العراق', latitude: 32.6167, longitude: 44.0242, fajrAngle: 18.0, ishaAngle: 17.0),

  // لبنان
  const CityInfo(name: 'بيروت', country: 'لبنان', latitude: 33.8938, longitude: 35.5018, fajrAngle: 18.0, ishaAngle: 17.0),

  // ليبيا
  const CityInfo(name: 'طرابلس', country: 'ليبيا', latitude: 32.8872, longitude: 13.1913, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'بنغازي', country: 'ليبيا', latitude: 32.0946, longitude: 20.1848, fajrAngle: 18.0, ishaAngle: 17.0),

  // تونس
  const CityInfo(name: 'تونس', country: 'تونس', latitude: 36.8065, longitude: 10.1815, fajrAngle: 18.0, ishaAngle: 17.0),

  // الجزائر
  const CityInfo(name: 'الجزائر', country: 'الجزائر', latitude: 36.7538, longitude: 3.0588, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'وهران', country: 'الجزائر', latitude: 35.6960, longitude: -0.6320, fajrAngle: 18.0, ishaAngle: 17.0),

  // المغرب
  const CityInfo(name: 'الرباط', country: 'المغرب', latitude: 33.9716, longitude: -6.8488, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'الدار البيضاء', country: 'المغرب', latitude: 33.5731, longitude: -7.5898, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'فاس', country: 'المغرب', latitude: 34.0181, longitude: -5.0168, fajrAngle: 18.0, ishaAngle: 17.0),

  // السودان
  const CityInfo(name: 'الخرطوم', country: 'السودان', latitude: 15.5007, longitude: 32.5599, fajrAngle: 18.0, ishaAngle: 17.0),

  // اليمن
  const CityInfo(name: 'صنعاء', country: 'اليمن', latitude: 15.3559, longitude: 44.2086, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'عدن', country: 'اليمن', latitude: 12.7895, longitude: 45.0367, fajrAngle: 18.0, ishaAngle: 17.0),

  // تركيا
  const CityInfo(name: 'إسطنبول', country: 'تركيا', latitude: 41.0082, longitude: 28.9784, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'أنقرة', country: 'تركيا', latitude: 39.9334, longitude: 32.8597, fajrAngle: 18.0, ishaAngle: 17.0),

  // باقي الدول
  const CityInfo(name: 'لندن', country: 'بريطانيا', latitude: 51.5074, longitude: -0.1278, fajrAngle: 15.0, ishaAngle: 14.0),
  const CityInfo(name: 'باريس', country: 'فرنسا', latitude: 48.8566, longitude: 2.3522, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'برلين', country: 'ألمانيا', latitude: 52.5200, longitude: 13.4050, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'روما', country: 'إيطاليا', latitude: 41.9028, longitude: 12.4964, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'مدريد', country: 'إسبانيا', latitude: 40.4168, longitude: -3.7038, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'واشنطن', country: 'أمريكا', latitude: 38.9072, longitude: -77.0369, fajrAngle: 15.0, ishaAngle: 15.0),
  const CityInfo(name: 'نيويورك', country: 'أمريكا', latitude: 40.7128, longitude: -74.0060, fajrAngle: 15.0, ishaAngle: 15.0),
  const CityInfo(name: 'تورنتو', country: 'كندا', latitude: 43.6532, longitude: -79.3832, fajrAngle: 15.0, ishaAngle: 15.0),
  const CityInfo(name: 'سيدني', country: 'أستراليا', latitude: -33.8688, longitude: 151.2093, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'كوالالمبور', country: 'ماليزيا', latitude: 3.1390, longitude: 101.6869, fajrAngle: 20.0, ishaAngle: 18.0),
  const CityInfo(name: 'جاكرتا', country: 'إندونيسيا', latitude: -6.2088, longitude: 106.8456, fajrAngle: 20.0, ishaAngle: 18.0),
  const CityInfo(name: 'إسلام آباد', country: 'باكستان', latitude: 33.6844, longitude: 73.0479, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'كابل', country: 'أفغانستان', latitude: 34.5553, longitude: 69.2075, fajrAngle: 18.0, ishaAngle: 17.0),
  const CityInfo(name: 'طهران', country: 'إيران', latitude: 35.6892, longitude: 51.3890, fajrAngle: 17.7, ishaAngle: 14.0),
  const CityInfo(name: 'مشهد', country: 'إيران', latitude: 36.2605, longitude: 59.6168, fajrAngle: 17.7, ishaAngle: 14.0),
];

final Map<String, List<CityInfo>> citiesByCountry = () {
  final map = <String, List<CityInfo>>{};
  for (final c in cities) {
    map.putIfAbsent(c.country, () => []);
    map[c.country]!.add(c);
  }
  return map;
}();
