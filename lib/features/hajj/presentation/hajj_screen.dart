import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class HajjScreen extends StatelessWidget {
  const HajjScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'الإحرام', 'desc': 'نية الدخول في النسك من الميقات.'},
      {'title': 'الطواف', 'desc': 'سبعة أشواط حول الكعبة المشرفة.'},
      {'title': 'السعي', 'desc': 'سبعة أشواط بين الصفا والمروة.'},
      {'title': 'يوم التروية', 'desc': 'الذهاب إلى منى في الثامن من ذي الحجة.'},
      {'title': 'الوقوف بعرفة', 'desc': 'أعظم أركان الحج في التاسع من ذي الحجة.'},
      {'title': 'المزدلفة', 'desc': 'المبيت بها بعد الانصراف من عرفة.'},
      {'title': 'رمي الجمار', 'desc': 'رمي جمرة العقبة الكبرى يوم العيد.'},
    ];

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('دليل الحج والعمرة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.lg),
        itemCount: steps.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.md),
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              color: AppColors.navyLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.goldMuted),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.gold,
                  child: Text('${i + 1}', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i]['title']!,
                        style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[i]['desc']!,
                        style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
