import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../../../core/utils/location_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  double _heading = 0;
  double _qiblaAngle = 0;
  bool _calibrating = true;
  bool _aligned = false;
  StreamSubscription? _compassSub;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    recordActivity(id: 'qibla', title: 'اتجاه القبلة', subtitle: '', route: '/qibla', icon: '🧭');
    _initQibla();
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _initQibla() async {
    final location = await LocationService().getCurrentLocation();
    setState(() {
      _qiblaAngle = _calculateQiblaAngle(location.latitude, location.longitude);
    });

    _compassSub?.cancel();
    _compassSub = FlutterCompass.events?.listen(
      (event) {
        if (!mounted) return;
        final heading = event.heading ?? _heading;
        final diff = (heading - _qiblaAngle).abs() % 360;
        final aligned = diff < 6 || diff > 354;
        setState(() {
          _heading = heading;
          _calibrating = false;
          if (aligned && !_aligned) {
            _pulseCtrl.repeat(reverse: true);
          } else if (!aligned && _aligned) {
            _pulseCtrl.stop();
            _pulseCtrl.reset();
          }
          _aligned = aligned;
        });
      },
      onError: (_) {
        if (mounted) setState(() => _calibrating = false);
      },
    );
  }

  double _calculateQiblaAngle(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final dLng = (kaabaLng - lng) * pi / 180;
    final latRad = lat * pi / 180;
    const kaabaLatRad = kaabaLat * pi / 180;
    final y = sin(dLng) * cos(kaabaLatRad);
    final x = cos(latRad) * sin(kaabaLatRad) - sin(latRad) * cos(kaabaLatRad) * cos(dLng);
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
          ? _buildCalibrating()
          : _buildCompass(),
    );
  }

  Widget _buildCalibrating() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.gold),
          const SizedBox(height: AppDimensions.lg),
          const Text('حرك الهاتف بشكل دائري للمعايرة',
            style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18)),
          const SizedBox(height: AppDimensions.md),
          Text('${_qiblaAngle.toStringAsFixed(1)}°',
            style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 14)),
          const SizedBox(height: AppDimensions.sm),
          ElevatedButton.icon(
            onPressed: _initQibla,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.navy),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    final needleAngle = (_qiblaAngle - _heading) * pi / 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Aligned banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
          decoration: BoxDecoration(
            color: _aligned ? AppColors.success.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: _aligned ? AppColors.success.withValues(alpha: 0.5) : Colors.transparent,
            ),
          ),
          child: _aligned
              ? AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, _) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 28),
                        SizedBox(width: 10),
                        Text('✅ تتجه نحو القبلة',
                          style: TextStyle(color: AppColors.success, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                )
              : const SizedBox(height: 44),
        ),
        const SizedBox(height: AppDimensions.lg),

        // Compass
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 3),
                  color: AppColors.navyLight,
                  boxShadow: [
                    BoxShadow(
                      color: _aligned ? AppColors.success.withValues(alpha: 0.3) : AppColors.goldMuted,
                      blurRadius: _aligned ? 30 : 20,
                    ),
                  ],
                ),
              ),
              // Inner ring
              Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
                ),
              ),
              // Degree ticks
              ...List.generate(72, (i) {
                final angle = (i * 5) * pi / 180;
                final isMain = i % 18 == 0;
                final len = isMain ? 20.0 : 10.0;
                final r1 = isMain ? 115.0 : 125.0;
                return Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 2,
                    height: 300,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: isMain ? 3 : 1.5,
                      height: len,
                      margin: EdgeInsets.only(top: r1 - len),
                      decoration: BoxDecoration(
                        color: isMain ? AppColors.gold : AppColors.goldMuted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                );
              }),
              // Cardinal directions
              ..._buildCardinalPoints(),
              // Qibla direction marker (fixed on compass)
              Transform.rotate(
                angle: (_qiblaAngle) * pi / 180,
                child: Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Icon(Icons.navigation, color: AppColors.success, size: 24),
                  ),
                ),
              ),
              // Kaaba center
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) {
                  final size = _aligned ? 72.0 * _pulseAnim.value : 72.0;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: _aligned
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _aligned ? AppColors.success : AppColors.gold,
                        width: _aligned ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _aligned ? AppColors.success.withValues(alpha: 0.3) : Colors.transparent,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('🕋', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  );
                },
              ),
              // Needle (rotates based on heading)
              Transform.rotate(
                angle: needleAngle,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _aligned
                              ? [AppColors.success, AppColors.success.withValues(alpha: 0.3)]
                              : [AppColors.gold, AppColors.gold.withValues(alpha: 0.3)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Container(width: 4, height: 40, color: Colors.transparent),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.lg),

        // Angle display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl, vertical: AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.navyLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.goldMuted),
          ),
          child: Column(
            children: [
              Text(
                '${_qiblaAngle.toStringAsFixed(1)}°',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'اتجاه القبلة',
                style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          _aligned ? '✔️ اتجاهك صحيح نحو القبلة' : 'حرك الهاتف حتى يتجه المؤشر نحو القبلة',
          style: TextStyle(
            color: _aligned ? AppColors.success : AppColors.textOnDarkMuted,
            fontFamily: 'Amiri',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCardinalPoints() {
    const labels = <_Cardinal>[
      _Cardinal('ش', 0.0, 'شمال'),
      _Cardinal('ج', pi, 'جنوب'),
      _Cardinal('غ', -pi / 2, 'غرب'),
      _Cardinal('ش_ق', pi / 2, 'شرق'),
    ];
    const r = 130.0;
    return labels.map((l) {
      final x = sin(l.angle) * r;
      final y = -cos(l.angle) * r;
      return Positioned(
        left: 150 + x - 14,
        top: 150 + y - 14,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              child: Center(
                child: Text(
                  l.label == 'ش_ق' ? 'ش' : l.label,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l.subtitle,
              style: const TextStyle(
                color: AppColors.textOnDarkMuted,
                fontFamily: 'Inter',
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _Cardinal {
  final String label;
  final double angle;
  final String subtitle;
  const _Cardinal(this.label, this.angle, this.subtitle);
}
