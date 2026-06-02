import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/quran/quran_providers.dart';
import '../../../core/utils/mushaf_cache.dart';
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

  @override
  void initState() {
    super.initState();
    final lastPage = _storage.getQuranPage();
    _currentPage = widget.initialPage > 0 ? widget.initialPage : lastPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    ref.read(mushafDownloadProgressProvider.notifier).checkStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveLastPage(int page) {
    _storage.saveQuranPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final dlState = ref.watch(mushafDownloadProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E7),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageController,
              itemCount: 604,
              reverse: true,
              onPageChanged: (idx) {
                setState(() => _currentPage = idx + 1);
                _saveLastPage(idx + 1);
              },
              itemBuilder: (context, idx) => _MushafPage(pageNumber: idx + 1),
            ),
          ),
          if (_showControls) _buildTopBar(),
          if (_showControls) _buildBottomBar(dlState),
        ],
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
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            Text('صفحة $_currentPage',
              style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.list_alt, color: Colors.white),
              onPressed: () => _showJumpToPage(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(AsyncValue<int?> dlState) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('$_currentPage / 604',
              style: const TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 14)),
            TextButton.icon(
              onPressed: () => _showPageTafsirList(context, _currentPage),
              icon: const Icon(Icons.menu_book, color: AppColors.gold, size: 18),
              label: const Text('التفسير', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
            ),
            _offlineBtn(dlState),
          ],
        ),
      ),
    );
  }

  Widget _offlineBtn(AsyncValue<int?> dlState) {
    return dlState.when(
      data: (count) {
        if (count == 604) {
          return const Text('بدون إنترنت ✓', style: TextStyle(color: AppColors.success, fontFamily: 'Amiri', fontSize: 13));
        }
        return GestureDetector(
          onTap: count == null || count == 0 ? _startDownload : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download,
                color: count != null && count > 0 ? AppColors.goldMuted : AppColors.gold,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                count != null && count > 0 ? 'جاري ($count/604)' : 'تحميل',
                style: TextStyle(
                  color: count != null && count > 0 ? AppColors.goldMuted : AppColors.gold,
                  fontFamily: 'Amiri',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
      ),
      error: (_, __) => const Text('خطأ', style: TextStyle(color: Colors.red, fontFamily: 'Amiri', fontSize: 13)),
    );
  }

  Future<void> _showPageTafsirList(BuildContext context, int page) async {
    final ayahs = await ref.read(pageAyahsProvider(page).future);
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _PageTafsirListSheet(ayahs: ayahs, pageNumber: page),
    );
  }

  Future<void> _startDownload() async {
    final shouldStart = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.navy,
        title: const Text('تحميل المصحف', textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18)),
        content: const Text('سيتم تحميل 604 صفحة للاستخدام بدون إنترنت. قد يستغرق هذا بضع دقائق.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('ابدأ التحميل', style: TextStyle(color: AppColors.gold))),
        ],
      ),
    );
    if (shouldStart == true) {
      ref.read(mushafDownloadProgressProvider.notifier).startDownload();
    }
  }

  void _showJumpToPage(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.navy,
        title: const Text('انتقل إلى صفحة', textAlign: TextAlign.center, style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri')),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: '1 - 604',
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.goldMuted)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.white70))),
          TextButton(
            onPressed: () {
              final p = int.tryParse(ctrl.text);
              if (p != null && p >= 1 && p <= 604) {
                _pageController.jumpToPage(p - 1);
                Navigator.pop(context);
              }
            },
            child: const Text('انتقال', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }
}

class _MushafPage extends ConsumerWidget {
  final int pageNumber;
  const _MushafPage({required this.pageNumber});

  static const String _baseUrl = 'https://raw.githubusercontent.com/QuranHub/quran-pages-images/main/easyquran.com/hafs-tajweed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref.read(mushafCacheServiceProvider).getPagePath(pageNumber),
      builder: (context, snapshot) {
        final localPath = snapshot.data;

        return InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.0,
          child: Container(
            color: const Color(0xFFFDF7E7),
            child: localPath != null && File(localPath).existsSync()
                ? Image.file(
                    File(localPath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _imageFallback(),
                  )
                : CachedNetworkImage(
                    imageUrl: '$_baseUrl/$pageNumber.jpg',
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
                    errorWidget: (_, __, ___) => _imageFallback(),
                  ),
          ),
        );
      },
    );
  }

  Widget _imageFallback() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppColors.goldMuted,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.menu_book, color: AppColors.gold, size: 32),
        ),
        const SizedBox(height: 16),
        Text('صفحة $pageNumber', style: const TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('اضغط لتحميل المصحف للاستخدام بدون إنترنت',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 14, color: AppColors.textOnDarkMuted)),
      ],
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
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppDimensions.xl),
          const Text('اختر الآية للتفسير', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
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
                      builder: (context) => _TafsirSheet(
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

class _TafsirSheet extends ConsumerWidget {
  final int surah;
  final int ayah;
  final String ayahText;
  const _TafsirSheet({required this.surah, required this.ayah, required this.ayahText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync = ref.watch(tafsirProvider((surah: surah, ayah: ayah)));
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppDimensions.xl),
          Text('سورة رقم $surah • آية رقم $ayah', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
          const SizedBox(height: AppDimensions.md),
          Text(ayahText, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(color: AppColors.goldMuted, height: 32),
          const Text('التفسير الميسر', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.md),
          tafsirAsync.when(
            loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator(color: AppColors.gold)),
            error: (_, __) => const Text('تعذر تحميل التفسير', style: TextStyle(color: Colors.red, fontFamily: 'Amiri')),
            data: (tafsir) => Text(tafsir, textAlign: TextAlign.justify, textDirection: TextDirection.rtl,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16, height: 1.6)),
          ),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }
}
