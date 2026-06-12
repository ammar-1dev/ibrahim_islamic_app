import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../../../data/quran/quran_providers.dart';
import '../../../core/storage/local_storage.dart';

class QuranMushafScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const QuranMushafScreen({super.key, this.initialPage = 0});

  @override
  ConsumerState<QuranMushafScreen> createState() => _QuranMushafScreenState();
}

class _QuranMushafScreenState extends ConsumerState<QuranMushafScreen> {
  late PageController _pageController;
  int _currentPage = 1;
  final _storage = LocalStorage();
  bool _showControls = true;
  bool _isNightMode = false;
  int _bookmarkedPage = 0;
  int _sessionResumePage = 1;

  @override
  void initState() {
    super.initState();
    recordActivity(id: 'mushaf', title: 'المصحف الشريف', subtitle: 'قراءة القرآن', route: '/mushaf', icon: '📖');
    final lastPage = _storage.getQuranPage();
    _currentPage = widget.initialPage > 0 ? widget.initialPage : lastPage;
    _sessionResumePage = _currentPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _isNightMode = _storage.getBool('mushaf_night_mode', defaultValue: false);
    _bookmarkedPage = _storage.getQuranBookmark();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveLastPage(int page) {
    _storage.saveQuranPage(page);
  }

  void _toggleNightMode() {
    setState(() {
      _isNightMode = !_isNightMode;
      _storage.saveBool('mushaf_night_mode', _isNightMode);
    });
  }

  void _onPageChanged(int idx) {
    final page = idx + 1;
    setState(() => _currentPage = page);
    _saveLastPage(page);
  }

  void _goToNextPage() {
    if (_currentPage < 604) {
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _pageController.animateToPage(
        _currentPage - 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleBookmark() {
    setState(() {
      _bookmarkedPage = _bookmarkedPage == _currentPage ? 0 : _currentPage;
      _sessionResumePage = _currentPage;
      _storage.saveQuranBookmark(_bookmarkedPage);
    });
    if (_bookmarkedPage == _currentPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الصفحة كعلامة مرجعية', style: TextStyle(fontFamily: 'Amiri')),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNightMode ? const Color(0xFF121212) : const Color(0xFFFDF7E7),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageController,
              itemCount: 604,
              reverse: true,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, idx) => _MushafPage(
                pageNumber: idx + 1,
                isNightMode: _isNightMode,
              ),
            ),
          ),
          _buildSideArrows(),
          if (_showControls) _buildTopBar(),
          if (_showControls) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSideArrows() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_showControls,
        child: AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Row(
            children: [
              GestureDetector(
                onTap: _currentPage > 1 ? _goToPreviousPage : null,
                child: Container(
                  width: 56,
                  alignment: Alignment.center,
                  child: _currentPage > 1
                      ? Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.navigate_before, color: Colors.white, size: 28),
                        )
                      : null,
                ),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: _currentPage < 604 ? _goToNextPage : null,
                child: Container(
                  width: 56,
                  alignment: Alignment.center,
                  child: _currentPage < 604
                      ? Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.navigate_next, color: Colors.white, size: 28),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.85), Colors.black.withValues(alpha: 0.15), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: Icon(_isNightMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                  onPressed: _toggleNightMode,
                  tooltip: 'الوضع الليلي',
                ),
                const Spacer(),
                Text('صفحة $_currentPage',
                  style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted, color: Colors.white),
                  onPressed: () => _showIndexSheet(context),
                  tooltip: 'فهرس السور',
                ),
              ],
            ),
                const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionChip(
                  icon: Icons.menu_book,
                  label: 'التفسير',
                  onTap: () => _showPageTafsir(context, _currentPage),
                ),
                const SizedBox(width: 12),
                _ActionChip(
                  icon: Icons.history_edu,
                  label: 'أسباب النزول',
                  onTap: () => _showPageTafsir(context, _currentPage),
                ),
                const SizedBox(width: 12),
                _ActionChip(
                  icon: _bookmarkedPage == _currentPage ? Icons.bookmark : Icons.bookmark_add_outlined,
                  label: _bookmarkedPage == _currentPage ? 'محفوظة' : 'علامة مرجعية',
                  iconColor: _bookmarkedPage == _currentPage ? AppColors.gold : Colors.white70,
                  onTap: _toggleBookmark,
                ),
                if (_bookmarkedPage > 0 && _bookmarkedPage != _currentPage) ...[
                  const SizedBox(width: 8),
                  _ActionChip(
                    icon: Icons.double_arrow,
                    label: 'انتقال',
                    iconColor: AppColors.gold,
                    onTap: () => _pageController.jumpToPage(_bookmarkedPage - 1),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final showResume = _currentPage != _sessionResumePage;
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentPage > 1)
              GestureDetector(
                onTap: _goToPreviousPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(Icons.navigate_before, color: Colors.white70, size: 20),
                      Text('السابقة', style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$_currentPage / 604',
                style: const TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 14)),
            ),
            if (_currentPage < 604)
              GestureDetector(
                onTap: _goToNextPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    children: [
                      Text('التالي', style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.bold)),
                      Icon(Icons.navigate_next, color: Colors.white70, size: 20),
                    ],
                  ),
                ),
              ),
            if (showResume)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _pageController.jumpToPage(_sessionResumePage - 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.goldMuted),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: AppColors.gold, size: 16),
                        const SizedBox(width: 4),
                        Text('عودة ($_sessionResumePage)', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showIndexSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _IndexSheet(
        onPageSelected: (page) {
          Navigator.pop(context);
          _pageController.jumpToPage(page - 1);
        },
      ),
    );
  }

  Future<void> _showPageTafsir(BuildContext context, int page) async {
    final ayahs = await ref.read(pageAyahsProvider(page).future);
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _PageTafsirListSheet(ayahs: ayahs, pageNumber: page),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  const _ActionChip({required this.icon, required this.label, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.goldMuted, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor ?? AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _MushafPage extends StatelessWidget {
  final int pageNumber;
  final bool isNightMode;
  const _MushafPage({required this.pageNumber, required this.isNightMode});

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'assets/mushaf/page_$pageNumber.jpg',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );

    if (isNightMode) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          -1,  0,  0, 0, 255,
           0, -1,  0, 0, 255,
           0,  0, -1, 0, 255,
           0,  0,  0, 1,   0,
        ]),
        child: image,
      );
    }

    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 3.0,
      child: Container(
        color: isNightMode ? const Color(0xFF121212) : const Color(0xFFFDF7E7),
        child: image,
      ),
    );
  }

  Widget _imageFallback() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64, height: 64,
          decoration: const BoxDecoration(
            color: AppColors.goldMuted,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.menu_book, color: AppColors.gold, size: 32),
        ),
        const SizedBox(height: 16),
        Text('صفحة $pageNumber', style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, color: isNightMode ? Colors.white : Colors.black)),
        const SizedBox(height: 8),
        const Text('الصفحة غير متاحة',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 14, color: AppColors.textOnDarkMuted)),
      ],
    );
  }
}

class _IndexSheet extends ConsumerWidget {
  final Function(int) onPageSelected;
  const _IndexSheet({required this.onPageSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('فهرس السور', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(color: AppColors.goldMuted, height: 32),
          Expanded(
            child: surahsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
              error: (_, __) => const Center(child: Text('خطأ في تحميل الفهرس', style: TextStyle(color: Colors.red))),
              data: (surahs) => ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  return ListTile(
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.goldMuted)),
                      alignment: Alignment.center,
                      child: Text('${surah.number}', style: const TextStyle(color: AppColors.gold, fontSize: 12)),
                    ),
                    title: Text(surah.nameArabic, style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18)),
                    subtitle: Text('${surah.revelationType == 'Meccan' ? 'مكية' : 'مدنية'} • آياتها ${surah.ayahs}',
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    trailing: Text('صفحة ${surah.startPage}', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
                    onTap: () => onPageSelected(surah.startPage),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageTafsirListSheet extends StatelessWidget {
  final List<dynamic> ayahs;
  final int pageNumber;
  const _PageTafsirListSheet({required this.ayahs, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppDimensions.xl),
          const Text('اختر الآية', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(color: AppColors.goldMuted, height: 32),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final a = ayahs[index];
                return ListTile(
                  title: Text(a['text'], textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18)),
                  subtitle: Text('سورة ${a['surah']['name']} • آية ${a['numberInSurah']}',
                    textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Amiri', fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => _TafsirTabsSheet(
                        surah: a['surah']['number'], ayah: a['numberInSurah'], ayahText: a['text']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirTabsSheet extends StatefulWidget {
  final int surah;
  final int ayah;
  final String ayahText;
  const _TafsirTabsSheet({required this.surah, required this.ayah, required this.ayahText});

  @override
  State<_TafsirTabsSheet> createState() => _TafsirTabsSheetState();
}

class _TafsirTabsSheetState extends State<_TafsirTabsSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.ayahText, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Text('سورة رقم ${widget.surah} • آية رقم ${widget.ayah}', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'التفسير الميسر'),
              Tab(text: 'معاني الكلمات'),
              Tab(text: 'أسباب النزول'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TafsirTab(surah: widget.surah, ayah: widget.ayah),
                const _ComingSoonTab(title: 'معاني الكلمات', icon: Icons.translate),
                const _ComingSoonTab(title: 'أسباب النزول', icon: Icons.history_edu),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirTab extends ConsumerWidget {
  final int surah;
  final int ayah;
  const _TafsirTab({required this.surah, required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync = ref.watch(tafsirProvider((surah: surah, ayah: ayah)));
    return tafsirAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      error: (_, __) => const Center(child: Text('تعذر تحميل التفسير', style: TextStyle(color: Colors.red, fontFamily: 'Amiri'))),
      data: (tafsir) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          tafsir.isEmpty ? 'التفسير غير متاح حالياً' : tafsir,
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 18, height: 1.8),
        ),
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String title;
  final IconData icon;
  const _ComingSoonTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.goldMuted, size: 64),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('سيتم تفعيل هذه الميزة في التحديث القادم إن شاء الله',
            style: TextStyle(color: Colors.white54, fontFamily: 'Amiri', fontSize: 16)),
        ],
      ),
    );
  }
}
