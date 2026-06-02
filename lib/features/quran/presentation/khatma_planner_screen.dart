import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class KhatmaPlannerScreen extends StatefulWidget {
  const KhatmaPlannerScreen({super.key});

  @override
  State<KhatmaPlannerScreen> createState() => _KhatmaPlannerScreenState();
}

class _KhatmaPlannerScreenState extends State<KhatmaPlannerScreen> {
  double _days = 30;
  int _partsPerDay = 1;

  void _calculate() {
    setState(() {
      _partsPerDay = (30 / _days).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('مخطط الختمة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'كم يوماً تريد لختم القرآن؟',
              style: TextStyle(
                color: AppColors.gold,
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            Center(
              child: Text(
                '${_days.toInt()} يوماً',
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Slider(
              value: _days,
              min: 3,
              max: 90,
              divisions: 87,
              activeColor: AppColors.gold,
              inactiveColor: AppColors.goldMuted,
              onChanged: (val) {
                setState(() => _days = val);
                _calculate();
              },
            ),
            const SizedBox(height: AppDimensions.xxl),
            Container(
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(color: AppColors.goldMuted),
              ),
              child: Column(
                children: [
                  const Text(
                    'خطة القراءة اليومية',
                    style: TextStyle(
                      color: AppColors.textOnDarkMuted,
                      fontFamily: 'Amiri',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_partsPerDay',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontFamily: 'Inter',
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      const Text(
                        'أجزاء يومياً',
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Amiri',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'بمعدل ${(604 / _days).toStringAsFixed(1)} صفحة في اليوم',
                    style: const TextStyle(
                      color: AppColors.textOnDarkMuted,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ خطة الختمة بنجاح')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: const Text(
                  'بدء الختمة',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
