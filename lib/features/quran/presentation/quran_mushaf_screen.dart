import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../../../core/utils/audio_service.dart';
import '../../../core/utils/quran_audio.dart';
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
  List<Map<String, dynamic>>? _surahPages;
  String _reciterKey = 'afs';

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
    _loadSurahPages();
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

  Future<void> _loadSurahPages() async {
    final str = await rootBundle.loadString('assets/quran/surah_pages.json');
    final data = json.decode(str) as List;
    _surahPages = data.cast<Map<String, dynamic>>();
  }

  int _getSurahForPage(int page) {
    if (_surahPages == null) return 1;
    int surah = 1;
    for (final entry in _surahPages!) {
      final surahNum = entry['surah'] as int;
      final surahPage = entry['page'] as int;
      if (surahPage <= page) {
        surah = surahNum;
      } else {
        break;
      }
    }
    return surah;
  }

  Future<void> _togglePlaySurah() async {
    final audio = ref.read(audioServiceProvider);
    if (audio.state.playing) {
      await audio.pause();
    } else {
      final surah = _getSurahForPage(_currentPage);
      final url = QuranAudio.getSurahUrl(surah, reciterKey: _reciterKey);
      await audio.play(url);
    }
  }

  String _reciterName() =>
      QuranAudio.reciters.entries.firstWhere((e) => e.value == _reciterKey).key;

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
    final surah = _getSurahForPage(_currentPage);
    final audio = ref.watch(audioServiceProvider);
    final isPlaying = audio.state.playing;

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _togglePlaySurah,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isPlaying ? AppColors.gold : Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: isPlaying ? AppColors.navy : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('سورة $surah', style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showReciterPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, color: Colors.white70, size: 13),
                        const SizedBox(width: 3),
                        Text(_reciterName(), style: const TextStyle(color: Colors.white70, fontFamily: 'Amiri', fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPage > 1)
                  GestureDetector(
                    onTap: _goToPreviousPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: const Row(
                        children: [
                          Icon(Icons.navigate_before, color: Colors.white70, size: 18),
                          Text('السابقة', style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('$_currentPage / 604',
                    style: const TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 12)),
                ),
                if (_currentPage < 604)
                  GestureDetector(
                    onTap: _goToNextPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: const Row(
                        children: [
                          Text('التالي', style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 13, fontWeight: FontWeight.bold)),
                          Icon(Icons.navigate_next, color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                if (showResume)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => _pageController.jumpToPage(_sessionResumePage - 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.goldMuted),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history, color: AppColors.gold, size: 14),
                            const SizedBox(width: 3),
                            Text('عودة ($_sessionResumePage)', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReciterPicker(BuildContext context) {
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('اختر القارئ', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(color: AppColors.goldMuted, height: 32),
            ...QuranAudio.reciters.entries.map((e) {
              final selected = e.value == _reciterKey;
              return ListTile(
                leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: AppColors.gold),
                title: Text(e.key, style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                trailing: selected ? const Icon(Icons.check, color: AppColors.gold) : null,
                onTap: () {
                  setState(() => _reciterKey = e.value);
                  Navigator.pop(ctx);
                  final audio = ref.read(audioServiceProvider);
                  if (audio.state.playing) {
                    final surah = _getSurahForPage(_currentPage);
                    audio.play(QuranAudio.getSurahUrl(surah, reciterKey: _reciterKey));
                  }
                },
              );
            }),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.goldMuted, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor ?? AppColors.gold, size: 11),
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 10, fontWeight: FontWeight.bold)),
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
                _WordMeaningsTab(surah: widget.surah, ayah: widget.ayah),
                _AsbabTab(surah: widget.surah, ayah: widget.ayah),
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

class _WordMeaningsTab extends ConsumerWidget {
  final int surah;
  final int ayah;
  const _WordMeaningsTab({required this.surah, required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(wordMeaningsProvider((surah: surah, ayah: ayah)));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: async.when(
        loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Center(child: CircularProgressIndicator(color: AppColors.gold))),
        error: (_, __) => const Text('تعذر تحميل معاني الكلمات', style: TextStyle(color: Colors.red, fontFamily: 'Amiri')),
        data: (words) {
          if (words.isEmpty) {
            return const Text('معاني الكلمات غير متاحة حالياً', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri'));
          }
          return Column(
            children: words.map((w) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: const BoxDecoration(color: AppColors.goldMuted, shape: BoxShape.circle),
                    child: Center(child: Text('${w.position}', style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(width: 10),
                  Text(w.arabic, textDirection: TextDirection.rtl, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
                    ),
                    child: Text(w.translation, style: const TextStyle(color: AppColors.goldLight, fontFamily: 'Inter', fontSize: 10)),
                  ),
                ],
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}

class _AsbabTab extends ConsumerWidget {
  final int surah;
  final int ayah;
  const _AsbabTab({required this.surah, required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(asbabProvider((surah: surah, ayah: ayah)));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: async.when(
        loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Center(child: CircularProgressIndicator(color: AppColors.gold))),
        error: (_, __) => const Text('تعذر تحميل سبب النزول', style: TextStyle(color: Colors.red, fontFamily: 'Amiri')),
        data: (text) => text.isEmpty
            ? const Text('لا يوجد سبب نزول مسجّل لهذه الآية', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri'))
            : Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.navyLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
                ),
                child: Text(text, textAlign: TextAlign.justify, textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 15, height: 1.6)),
              ),
      ),
    );
  }
}
