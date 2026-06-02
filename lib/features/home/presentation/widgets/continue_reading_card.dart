import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../quran/presentation/quran_mushaf_screen.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = LocalStorage();
    final lastPage = storage.getQuranPage();

    if (lastPage <= 1) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuranMushafScreen(initialPage: lastPage)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.lg),
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D4B7A), AppColors.navy],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_book, color: AppColors.gold),
            ),
            const SizedBox(width: AppDimensions.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تابع القراءة',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'أكمل من حيث توقفت في المصحف الشريف',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Amiri',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text(
                  'صفحة',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Text(
                  '$lastPage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
