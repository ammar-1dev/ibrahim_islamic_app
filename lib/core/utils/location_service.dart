import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cities_data.dart';

class LocationService {
  static const double _defaultLat = 30.0444;
  static const double _defaultLng = 31.2357;
  static const String _cityKey = 'selected_city_name';

  CityInfo? _cachedCity;

  Future<CityInfo?> getSelectedCity() async {
    if (_cachedCity != null) return _cachedCity;
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_cityKey);
    if (name != null) {
      _cachedCity = cities.cast<CityInfo?>().firstWhere(
        (c) => c!.name == name,
        orElse: () => null,
      );
    }
    return _cachedCity;
  }

  Future<void> setSelectedCity(CityInfo city) async {
    _cachedCity = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, city.name);
  }

  Future<Position> getCurrentLocation() async {
    final selected = await getSelectedCity();
    if (selected != null) {
      return _position(selected.latitude, selected.longitude);
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        try {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 10),
          );
        } catch (_) {}
      }
    }

    return _position(_defaultLat, _defaultLng);
  }

  Position _position(double lat, double lng) => Position(
        latitude: lat,
        longitude: lng,
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
