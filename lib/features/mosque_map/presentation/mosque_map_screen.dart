import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/providers.dart';

class MosqueMapScreen extends ConsumerStatefulWidget {
  const MosqueMapScreen({super.key});

  @override
  ConsumerState<MosqueMapScreen> createState() => _MosqueMapScreenState();
}

class _MosqueMapScreenState extends ConsumerState<MosqueMapScreen> {
  LatLng? _currentPosition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final location = await ref.read(locationServiceProvider).getCurrentLocation();
    setState(() {
      _currentPosition = LatLng(location.latitude, location.longitude);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('خريطة المساجد'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _currentPosition == null
              ? const Center(
                  child: Text('تعذر تحديد موقعك', style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18)),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    // Future: Add nearby mosques markers via Places API
                  },
                  style: _mapStyle(),
                ),
    );
  }

  String? _mapStyle() {
    return '''[
      {
        "elementType": "geometry",
        "stylers": [
          {"color": "#0F1C3A"}
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#C9A84C"}
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {"color": "#0F1C3A"}
        ]
      }
    ]''';
  }
}

// Add route in app_router.dart:
// GoRoute(path: '/mosque-map', builder: (context, state) => const MosqueMapScreen()),
