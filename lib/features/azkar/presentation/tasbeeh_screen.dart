import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _target = 33;
  int _cycles = 0;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  final List<Map<String, dynamic>> _presets = [
    {'text': 'سبحان الله', 'target': 33},
    {'text': 'الحمد لله', 'target': 33},
    {'text': 'الله أكبر', 'target': 34},
    {'text': 'لا إله إلا الله', 'target': 100},
    {'text': 'استغفر الله', 'target': 100},
  ];
  int _presetIndex = 0;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
    _target = _presets[_presetIndex]['target'] as int;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _increment() {
    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) => _scaleController.reverse());
    setState(() {
      _count++;
      if (_count >= _target) {
        _cycles++;
        _count = 0;
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _reset() {
    setState(() { _count = 0; _cycles = 0; });
  }

  void _selectPreset(int i) {
    setState(() {
      _presetIndex = i;
      _target = _presets[i]['target'] as int;
      _count = 0;
      _cycles = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('المسبحة الذكية'),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, color: AppColors.gold),
          ),
        ],
      ),
      body: Column(
        children: [
          // Preset selector
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              itemCount: _presets.length,
              itemBuilder: (context, i) {
                final selected = i == _presetIndex;
                return GestureDetector(
                  onTap: () => _selectPreset(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: AppDimensions.sm, top: 8, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.gold : AppColors.navyLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(color: selected ? AppColors.gold : AppColors.goldMuted),
                    ),
                    child: Center(
                      child: Text(
                        _presets[i]['text'] as String,
                        style: TextStyle(
                          color: selected ? AppColors.navy : AppColors.textOnDark,
                          fontFamily: 'Amiri',
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          // Counter display
          Text(
            _presets[_presetIndex]['text'] as String,
            style: const TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          Text(
            '$_count',
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Inter',
              fontSize: 72,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'من $_target',
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Amiri',
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          // Progress circle
          SizedBox(
            width: 200,
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: _count / _target,
                backgroundColor: AppColors.navyLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                minHeight: 8,
              ),
            ),
          ),
          if (_cycles > 0) ...[
            const SizedBox(height: AppDimensions.md),
            Text(
              'الجولات: $_cycles',
              style: const TextStyle(
                color: AppColors.gold,
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const Spacer(),
          // Tap button
          ScaleTransition(
            scale: _scaleAnim,
            child: GestureDetector(
              onTap: _increment,
              child: Container(
                width: 180,
                height: 180,
                margin: const EdgeInsets.only(bottom: AppDimensions.xxl),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [AppColors.goldLight, AppColors.gold],
                  ),
                  boxShadow: const [
                    BoxShadow(color: AppColors.goldMuted, blurRadius: 24, spreadRadius: 4),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.grain, color: AppColors.navy, size: 48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
