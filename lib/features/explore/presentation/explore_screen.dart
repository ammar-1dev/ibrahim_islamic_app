import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  int _selectedFilter = 0;

  final List<String> _filters = ['الكل', 'الأذكار', 'الأدعية', 'الأحاديث', 'العبادات', 'الكتب', 'التفسير', 'السيرة'];

  final List<Map<String, dynamic>> _items = [
    {'emoji': '💰', 'name': 'حاسبة الزكاة', 'detail': 'احسب زكاتك بدقة', 'category': 'الكل', 'route': '/zakat'},
    {'emoji': '📅', 'name': 'التقويم الهجري', 'detail': 'المناسبات والتواريخ', 'category': 'الكل', 'route': '/calendar'},
    {'emoji': '🕋', 'name': 'دليل الحج والعمرة', 'detail': 'خطوات النسك بوضوح', 'category': 'الكل', 'route': '/hajj'},
    {'emoji': '✨', 'name': 'أسماء الله الحسنى', 'detail': '99 اسماً ومعانيها', 'category': 'الكل', 'route': '/names'},
    {'emoji': '🕋', 'name': 'اتجاه القبلة', 'detail': 'بوصلة دقيقة', 'category': 'الكل', 'route': '/qibla'},
    {'emoji': '📿', 'name': 'المسبحة الذكية', 'detail': 'عداد + تنبيه', 'category': 'الكل', 'route': '/tasbeeh'},
    {'emoji': '🌅', 'name': 'أذكار الصباح', 'detail': 'أذكار الصباح', 'category': 'الأذكار', 'route': '/morning-adhkar'},
    {'emoji': '🌙', 'name': 'أذكار المساء', 'detail': 'أذكار المساء', 'category': 'الأذكار', 'route': '/evening-adhkar'},
    {'emoji': '📿', 'name': 'الأذكار المنوعة', 'detail': 'أذكار المناسبات', 'category': 'الأذكار', 'route': '/occasions-adhkar'},
    {'emoji': '🤲', 'name': 'أدعية القرآن', 'detail': '40+ دعاء', 'category': 'الأدعية', 'route': '/dua'},
    {'emoji': '📜', 'name': 'الأربعون النووية', 'detail': '42 حديثاً', 'category': 'الأحاديث', 'route': '/hadith/3'},
    {'emoji': '📚', 'name': 'صحيح البخاري', 'detail': '7277 حديثاً', 'category': 'الأحاديث', 'route': '/hadith/1'},
    {'emoji': '📚', 'name': 'صحيح مسلم', 'detail': '7459 حديثاً', 'category': 'الأحاديث', 'route': '/hadith/2'},
    {'emoji': '⭐', 'name': 'رياض الصالحين', 'detail': '1903 حديث', 'category': 'الأحاديث', 'route': '/hadith'},
    {'emoji': '📍', 'name': 'خريطة المساجد', 'detail': 'مساجد قريبة منك', 'category': 'الكل', 'route': '/mosque-map'},
    {'emoji': '🎧', 'name': 'استماع القرآن', 'detail': 'تلاوة السور', 'category': 'الكل', 'route': '/surah-audio'},
    {'emoji': '💝', 'name': 'تتبع الصدقة', 'detail': 'سجل صدقاتك', 'category': 'الكل', 'route': '/sadaqah'},
    {'emoji': '📖', 'name': 'فقه العبادات', 'detail': 'أحكام الصلاة والطهارة والصوم والزكاة والحج', 'category': 'العبادات', 'route': '/fiqh'},
    {'emoji': '📋', 'name': 'الورد اليومي', 'detail': 'برنامجك الروحي', 'category': 'الكل', 'route': '/wird'},
    {'emoji': '🔍', 'name': 'البحث في القرآن', 'detail': 'ابحث عن أي آية', 'category': 'الكل', 'route': '/quran-search'},
    {'emoji': '📑', 'name': 'العلامات المرجعية', 'detail': 'آياتك المحفوظة', 'category': 'الكل', 'route': '/bookmarks'},
    {'emoji': '📖', 'name': 'كتاب أسباب النزول', 'detail': 'أسباب نزول الآيات والسور', 'category': 'التفسير', 'route': '/asbab-book'},
    {'emoji': '📚', 'name': 'المكتبة الإسلامية', 'detail': '200+ كتاب', 'category': 'الكتب', 'route': '/books'},
    {'emoji': '🕌', 'name': 'السيرة النبوية', 'detail': 'الرحيق المختوم ومصادر أخرى', 'category': 'السيرة', 'route': '/seerah'},
    {'emoji': '📖', 'name': 'الرحيق المختوم', 'detail': 'السيرة النبوية الكاملة', 'category': 'السيرة', 'route': '/seerah'},
    {'emoji': '📜', 'name': 'زاد المعاد', 'detail': 'فقه السيرة والهدي النبوي', 'category': 'السيرة', 'route': '/book-reader/9'},
    {'emoji': '🎨', 'name': 'المصحف الملون بالأحكام', 'detail': 'قراءة بالتجويد', 'category': 'الكل', 'route': '/tajweed-reader'},
    {'emoji': '👩', 'name': 'قسم المرأة', 'detail': 'أحكام وأدعية خاصة', 'category': 'الكل', 'route': '/womens-section'},
    {'emoji': '🕊️', 'name': 'الرقية الشرعية', 'detail': 'آيات وأدعية للتحصين', 'category': 'الكل', 'route': '/ruqyah'},
    {'emoji': '🏆', 'name': 'التحديات', 'detail': 'إنجازات ومسابقات قرآنية', 'category': 'الكل', 'route': '/social'},
  ];

  List<Map<String, dynamic>> get _filtered {
    final filter = _filters[_selectedFilter];
    List<Map<String, dynamic>> result = filter == 'الكل' ? _items : _items.where((i) => i['category'] == filter).toList();
    final q = _searchCtrl.text;
    if (q.isNotEmpty) result = result.where((i) => (i['name'] as String).contains(q)).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('استكشف'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: Column(
                children: [
                  // Search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'ابحث في المكتبة...',
                      hintStyle: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16),
                      prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                      filled: true,
                      fillColor: AppColors.navyLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        borderSide: const BorderSide(color: AppColors.goldMuted),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, i) {
                        final selected = i == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: AppDimensions.sm),
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.gold : AppColors.navyLight,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                              border: Border.all(color: selected ? AppColors.gold : AppColors.goldMuted),
                            ),
                            child: Text(
                              _filters[i],
                              style: TextStyle(
                                color: selected ? AppColors.navy : AppColors.textOnDark,
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  // AI Featured card
                  _FeaturedAICard(),
                  const SizedBox(height: AppDimensions.lg),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: AppDimensions.md,
                mainAxisSpacing: AppDimensions.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _filtered[index];
                  return _ExploreCard(item: item);
                },
                childCount: _filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
        ],
      ),
    );
  }
}

class _FeaturedAICard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ai-assistant'),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A2C4E), Color(0xFF0F1C3A)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.goldMuted,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: const Icon(Icons.mosque, color: AppColors.gold, size: 28),
            ),
            const SizedBox(width: AppDimensions.lg),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إبراهيم AI',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'مساعدك الإسلامي الذكي — اسألني أي شيء',
                    style: TextStyle(
                      color: AppColors.textOnDarkMuted,
                      fontFamily: 'Amiri',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.gold, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ExploreCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final route = item['route'] as String?;
        if (route != null) context.push(route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.goldMuted),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item['emoji'] as String, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: AppDimensions.xs),
            Text(
              item['name'] as String,
              style: const TextStyle(
                color: AppColors.textOnDark,
                fontFamily: 'Amiri',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
            ),
            Text(
              item['detail'] as String,
              style: const TextStyle(
                color: AppColors.textOnDarkMuted,
                fontFamily: 'Inter',
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
