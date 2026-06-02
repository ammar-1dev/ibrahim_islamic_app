import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/location_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double _heading = 0;
  double _qiblaAngle = 0;
  bool _calibrating = true;
  bool _aligned = false;

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  Future<void> _initQibla() async {
    final location = await LocationService().getCurrentLocation();
    setState(() {
      _qiblaAngle = _calculateQiblaAngle(
          location.latitude, location.longitude);
    });

    FlutterCompass.events?.listen((event) {
      if (!mounted) return;
      final heading = event.heading ?? 0;
      final diff = (heading - _qiblaAngle).abs() % 360;
      final aligned = diff < 5 || diff > 355;
      setState(() {
        _heading = heading;
        _calibrating = false;
        _aligned = aligned;
      });
    });
  }

  /// حساب زاوية القبلة من موقع المستخدم
  double _calculateQiblaAngle(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    final dLng = (kaabaLng - lng) * pi / 180;
    final latRad = lat * pi / 180;
    final kaabaLatRad = kaabaLat * pi / 180;

    final y = sin(dLng) * cos(kaabaLatRad);
    final x = cos(latRad) * sin(kaabaLatRad) -
        sin(latRad) * cos(kaabaLatRad) * cos(dLng);
    final angle = atan2(y, x) * 180 / pi;
    return (angle + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _calibrating
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.gold),
                  SizedBox(height: 16),
                  Text('جاري تحديد الاتجاه...', style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18)),
                ],
              ),
            )
          : _buildCompass(),
    );
  }

  Widget _buildCompass() {
    // needle angle = qibla - current heading
    final needleAngle = (_qiblaAngle - _heading) * pi / 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Aligned banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: _aligned ? AppColors.success.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: _aligned ? AppColors.success : Colors.transparent,
            ),
          ),
          child: _aligned
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    SizedBox(width: 8),
                    Text('أنت تتجه نحو القبلة', style: TextStyle(color: AppColors.success, fontFamily: 'Amiri', fontSize: 18)),
                  ],
                )
              : const SizedBox(height: 44),
        ),
        const SizedBox(height: AppDimensions.xl),
        // Compass
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 3),
                  color: AppColors.navyLight,
                  boxShadow: const [
                    BoxShadow(color: AppColors.goldMuted, blurRadius: 20),
                  ],
                ),
              ),
              // Cardinal points
              ..._buildCardinalPoints(),
              // Kaabah icon in center
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: const Icon(Icons.mosque, color: AppColors.gold, size: 28),
              ),
              // Needle
              Transform.rotate(
                angle: needleAngle,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 110,
                      decoration: BoxDecoration(
                        color: _aligned ? AppColors.success : AppColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 30,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        Text(
          '${_qiblaAngle.toStringAsFixed(1)}°',
          style: const TextStyle(
            color: AppColors.gold,
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          'اتجاه القبلة',
          style: TextStyle(
            color: AppColors.textOnDarkMuted,
            fontFamily: 'Amiri',
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCardinalPoints() {
    final labels = [
      ('ش', 0.0),
      ('ج', pi),
      ('غ', -pi / 2),
      ('ق', pi / 2),
    ];
    return labels.map((l) {
      const r = 120.0;
      final x = sin(l.$2) * r;
      final y = -cos(l.$2) * r;
      return Positioned(
        left: 140 + x - 10,
        top: 140 + y - 10,
        child: Text(
          l.$1,
          style: const TextStyle(
            color: AppColors.textOnDarkMuted,
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }).toList();
  }
}
