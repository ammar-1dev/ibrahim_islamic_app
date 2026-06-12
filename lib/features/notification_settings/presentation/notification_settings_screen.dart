import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/notification_service.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = LocalStorage();

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          _buildSectionHeader('أوقات الصلاة'),
          _buildToggle(
            icon: Icons.mosque,
            title: 'إشعارات أوقات الصلاة',
            subtitle: 'تنبيه عند دخول وقت كل صلاة',
            value: storage.isPrayerNotificationEnabled(),
            onChanged: (v) async {
              await storage.setPrayerNotificationEnabled(v);
              if (v) {
                await NotificationService().scheduleAllPrayerNotifications();
              } else {
                await NotificationService().cancelPrayerNotifications();
              }
            },
          ),
          const SizedBox(height: AppDimensions.xl),
          _buildSectionHeader('الأذكار'),
          _buildToggle(
            icon: Icons.wb_sunny_outlined,
            title: 'أذكار الصباح',
            subtitle: 'تنبيه بعد شروق الشمس بأذكار الصباح',
            value: storage.isAzkarMorningNotificationEnabled(),
            onChanged: (v) async {
              await storage.setAzkarMorningNotificationEnabled(v);
              if (v) {
                await NotificationService().scheduleMorningAzkarNotification();
              } else {
                await NotificationService().cancelAzkarNotifications();
                if (storage.isAzkarEveningNotificationEnabled()) {
                  await NotificationService().scheduleEveningAzkarNotification();
                }
              }
            },
          ),
          const SizedBox(height: AppDimensions.md),
          _buildToggle(
            icon: Icons.nightlight_round,
            title: 'أذكار المساء',
            subtitle: 'تنبيه بعد صلاة العصر بأذكار المساء',
            value: storage.isAzkarEveningNotificationEnabled(),
            onChanged: (v) async {
              await storage.setAzkarEveningNotificationEnabled(v);
              if (v) {
                await NotificationService().scheduleEveningAzkarNotification();
              } else {
                await NotificationService().cancelAzkarNotifications();
                if (storage.isAzkarMorningNotificationEnabled()) {
                  await NotificationService().scheduleMorningAzkarNotification();
                }
              }
            },
          ),
          const SizedBox(height: AppDimensions.xl),
          _buildSectionHeader('تذكيرات متنوعة'),
          _buildToggle(
            icon: Icons.notifications_active,
            title: 'تذكير بذكر الله والصلاة على النبي',
            subtitle: 'تنبيهات عشوائية خلال اليوم',
            value: storage.isReminderNotificationEnabled(),
            onChanged: (v) async {
              await storage.setReminderNotificationEnabled(v);
              if (v) {
                await NotificationService().scheduleReminderNotifications();
              } else {
                await NotificationService().cancelReminderNotifications();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.gold,
          fontFamily: 'Amiri',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textOnDark,
            fontFamily: 'Amiri',
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textOnDarkMuted,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.gold,
          activeTrackColor: AppColors.goldMuted,
        ),
      ),
    );
  }
}
