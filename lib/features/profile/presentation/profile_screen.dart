import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/storage/local_storage.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final storage = LocalStorage();
    final bookmarks = storage.getBookmarks();
    final quranPage = storage.getQuranPage();
    final spiritualLevel = storage.getSpiritualLevel();

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppDimensions.xl),
            _buildStatsRow(quranPage, bookmarks.length, spiritualLevel),
            const SizedBox(height: AppDimensions.xl),
            _buildMenuSection(context, ref, themeMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyLight, Color(0xFF1E3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: AppColors.goldMuted,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.person, color: AppColors.gold, size: 44),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          const Text('المستخدم', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 24, fontWeight: FontWeight.w700)),
          const Text('حساب محلي', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int quranPage, int bookmarkCount, int spiritualLevel) {
    return Row(
      children: [
        _buildStatCard('صفحات القرآن', '$quranPage/604', Icons.menu_book),
        const SizedBox(width: AppDimensions.md),
        _buildStatCard('الإشارات', '$bookmarkCount', Icons.bookmark),
        const SizedBox(width: AppDimensions.md),
        _buildStatCard('المستوى', '$spiritualLevel', Icons.track_changes),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.goldMuted),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.gold, size: 22),
            const SizedBox(height: AppDimensions.sm),
            Text(value, style: const TextStyle(color: AppColors.white, fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.notifications,
          title: 'الإشعارات',
          onTap: () => context.push('/notification-settings'),
        ),
        _buildMenuItem(
          icon: Icons.dark_mode,
          title: 'المظهر',
          trailing: Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(themeModeNotifierProvider.notifier).toggleTheme(),
            activeThumbColor: AppColors.gold,
          ),
        ),
        _buildMenuItem(
          icon: Icons.bookmark,
          title: 'الإشارات',
          subtitle: '${LocalStorage().getBookmarks().length} إشارة',
          onTap: () => _showBookmarks(context),
        ),
        _buildMenuItem(
          icon: Icons.share,
          title: 'مشاركة التطبيق',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'عن التطبيق',
          onTap: () => _showAbout(context),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title, style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)) : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: AppColors.gold, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showBookmarks(BuildContext context) {
    final storage = LocalStorage();
    final bookmarks = storage.getBookmarks();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppDimensions.lg),
            const Text('الإشارات', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 22, fontWeight: FontWeight.w700)),
            const Divider(color: AppColors.goldMuted),
            if (bookmarks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.xxl),
                child: Text('لا توجد إشارات بعد', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
              )
            else
              ...bookmarks.map((b) => ListTile(
                title: Text(b, style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 14)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                  onPressed: () {
                    storage.removeBookmark(b);
                    Navigator.pop(context);
                    _showBookmarks(context);
                  },
                ),
              )),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'إبراهيم',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.mosque, color: AppColors.navy, size: 28),
      ),
      children: [
        const Text('مرافقك الروحي اليومي', style: TextStyle(fontFamily: 'Amiri', fontSize: 16)),
      ],
    );
  }
}
