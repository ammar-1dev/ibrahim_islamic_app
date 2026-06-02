import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late HijriCalendar _today;

  final List<Map<String, dynamic>> _events = [
    {'name': 'بداية رمضان', 'month': 9, 'day': 1, 'color': Colors.green},
    {'name': 'عيد الفطر', 'month': 10, 'day': 1, 'color': AppColors.gold},
    {'name': 'يوم عرفة', 'month': 12, 'day': 9, 'color': Colors.blue},
    {'name': 'عيد الأضحى', 'month': 12, 'day': 10, 'color': AppColors.gold},
    {'name': 'رأس السنة الهجرية', 'month': 1, 'day': 1, 'color': Colors.orange},
    {'name': 'عاشوراء', 'month': 1, 'day': 10, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('التقويم الهجري'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          children: [
            _buildMonthCard(),
            const SizedBox(height: AppDimensions.xl),
            _buildEventsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            _today.longMonthName,
            style: const TextStyle(
              color: AppColors.gold,
              fontFamily: 'Amiri',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${_today.hYear} هـ',
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          // Day number
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: Center(
              child: Text(
                '${_today.hDay}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            _today.getDayName(),
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontFamily: 'Amiri',
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أهم المناسبات الإسلامية',
          style: TextStyle(
            color: AppColors.gold,
            fontFamily: 'Amiri',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        ..._events.map((e) => _buildEventItem(e)),
      ],
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: event['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              event['name'] as String,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
            ),
          ),
          Text(
            '${event['day']} / ${event['month']}',
            style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 14),
          ),
        ],
      ),
    );
  }
}
