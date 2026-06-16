import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/font_size_provider.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/services/locale_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final fontScale = ref.watch(fontScaleNotifierProvider);
    final locale = ref.watch(localeProvider);
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
            _buildMenuSection(context, ref, themeMode, fontScale, locale),
            const SizedBox(height: AppDimensions.xl),
            _buildFooter(),
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

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, ThemeMode themeMode, double fontScale, Locale locale) {
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
          subtitle: _themeModeLabel(themeMode),
          onTap: () => ref.read(themeModeNotifierProvider.notifier).toggleTheme(),
        ),
        _buildMenuItem(
          icon: Icons.language,
          title: 'اللغة',
          subtitle: _localeLabel(locale),
          onTap: () => _showLocaleSheet(context, ref),
        ),
        _buildMenuItem(
          icon: Icons.text_fields,
          title: 'حجم الخط',
          subtitle: _fontSizeLabel(fontScale),
          onTap: () => _showFontSizeSheet(context, ref, fontScale),
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
          onTap: () => _shareApp(),
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'عن التطبيق',
          onTap: () => _showAbout(context),
        ),
        _buildMenuItem(
          icon: Icons.chat,
          title: 'مراسلة المطور',
          subtitle: 'واتساب',
          onTap: () => _openWhatsApp(),
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

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'نهاري';
      case ThemeMode.system:
        return 'تلقائي';
      case ThemeMode.dark:
        return 'ليلي';
    }
  }

  String _fontSizeLabel(double scale) {
    if (scale <= 0.9) return 'صغير';
    if (scale <= 1.05) return 'متوسط';
    if (scale <= 1.25) return 'كبير';
    return 'كبير جداً';
  }

  String _localeLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ar': return 'العربية';
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'ru': return 'Русский';
      case 'tr': return 'Türkçe';
      case 'es': return 'Español';
      default: return 'English';
    }
  }

  void _showLocaleSheet(BuildContext context, WidgetRef ref) {
    final locales = [
      const Locale('ar'), const Locale('en'), const Locale('fr'),
      const Locale('ru'), const Locale('tr'), const Locale('es'),
    ];
    final labels = ['العربية', 'English', 'Français', 'Русский', 'Türkçe', 'Español'];
    final current = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            const Text('اللغة', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 22, fontWeight: FontWeight.w700)),
            const Divider(color: AppColors.goldMuted),
            ...List.generate(locales.length, (i) {
              final isSelected = current.languageCode == locales[i].languageCode;
              return ListTile(
                title: Text(labels[i], style: const TextStyle(
                  color: AppColors.textOnDark,
                  fontFamily: 'Amiri',
                  fontSize: 16,
                )),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.gold) : null,
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale(locales[i]);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFontSizeSheet(BuildContext context, WidgetRef ref, double currentScale) {
    final options = [
      {'label': 'صغير', 'scale': 0.85},
      {'label': 'متوسط', 'scale': 1.0},
      {'label': 'كبير', 'scale': 1.15},
      {'label': 'كبير جداً', 'scale': 1.3},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            const Text('حجم الخط', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 22, fontWeight: FontWeight.w700)),
            const Divider(color: AppColors.goldMuted),
            ...options.map((opt) {
              final scale = opt['scale'] as double;
              final label = opt['label'] as String;
              final isSelected = currentScale == scale;
              return ListTile(
                title: Text(label, style: TextStyle(
                  color: AppColors.textOnDark,
                  fontFamily: 'Amiri',
                  fontSize: 16,
                )),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.gold) : null,
                onTap: () {
                  ref.read(fontScaleNotifierProvider.notifier).setFontScale(scale);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.xl, horizontal: AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/images/app_icon.png', height: 48, width: 48),
          ),
          const SizedBox(height: AppDimensions.md),
          const Text(
            'تطبيق إبراهيم',
            style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.goldMuted),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, color: AppColors.gold, size: 16),
                SizedBox(width: 8),
                Text(
                  'لا تنسونا من صالح دعائكم',
                  style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.favorite, color: AppColors.gold, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    Share.share(
      'تطبيق إبراهيم - رفيقك الروحي اليومي\n'
      'كل ما تحتاجه لرحلة إيمانية متكاملة: قرآن، أذكار، أدعية، مواقيت الصلاة، وأكثر!\n'
      'حمّله الآن',
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

  Future<void> _openWhatsApp() async {
    const phone = '00967774561368';
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.navyLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.mosque, color: AppColors.navy, size: 32),
              ),
              const SizedBox(height: AppDimensions.md),
              const Text('إبراهيم', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 26, fontWeight: FontWeight.bold)),
              const Text('الإصدار 1.0.0', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
              const SizedBox(height: AppDimensions.md),
              const Text('مرافقك الروحي اليومي', textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16)),
              const SizedBox(height: AppDimensions.lg),
              Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: AppColors.goldMuted),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: AppColors.gold, size: 18),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'لا تنسونا من صالح دعائكم',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.favorite, color: AppColors.gold, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () { Navigator.pop(context); _openWhatsApp(); },
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('مراسلة المطور عبر واتساب', style: TextStyle(fontFamily: 'Amiri', fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
