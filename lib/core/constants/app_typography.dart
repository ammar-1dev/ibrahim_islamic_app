import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Arabic Font: Amiri
  static const arabicHeading = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const arabicBody = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 2.0,
  );

  static const quranText = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 2.2,
    color: AppColors.gold,
  );

  // English/UI Font: Inter
  static const uiLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const uiBody = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const uiHeading = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}
