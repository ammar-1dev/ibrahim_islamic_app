import 'package:geolocator/geolocator.dart';

/// خدمة الموقع الجغرافي
class LocationService {
  static const double _defaultLat = 21.3891; // مكة المكرمة — الافتراضي
  static const double _defaultLng = 39.8579;

  /// يعيد الموقع الحالي للمستخدم، مع الرجوع إلى مكة إذا فشل
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return _defaultPosition();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return _defaultPosition();
    }
    if (permission == LocationPermission.deniedForever) return _defaultPosition();

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (_) {
      return _defaultPosition();
    }
  }

  Position _defaultPosition() => Position(
        latitude: _defaultLat,
        longitude: _defaultLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
}
