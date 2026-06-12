import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../../../data/quran/quran_providers.dart';
import '../../../data/quran/surah_meta.dart';
import '../data/search_service.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

final globalSearchProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) {
  if (query.trim().isEmpty) return [];
  return ref.read(searchServiceProvider).search(query);
});

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    recordActivity(id: 'global_search', title: 'البحث الشامل', subtitle: 'بحث في جميع الموارد', route: '/global-search', icon: '🔍');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quranAsync = ref.watch(searchQuranProvider(_query));
    final globalAsync = ref.watch(globalSearchProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('البحث الشامل', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
              decoration: InputDecoration(
                hintText: 'ابحث في القرآن، الحديث، الأدعية، الأذكار، الكتب...',
                hintStyle: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textOnDarkMuted),
                        onPressed: () {
                          _ctrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.navyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusLg)),
                  borderSide: BorderSide(color: AppColors.goldMuted),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusLg)),
                  borderSide: BorderSide(color: AppColors.gold),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyState()
                : _buildResults(quranAsync, globalAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, color: AppColors.gold.withValues(alpha: 0.3), size: 64),
          const SizedBox(height: 16),
          const Text('ابحث عن أي شيء...',
            style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
          const SizedBox(height: 8),
          const Text('القرآن — الحديث — الأدعية — الأذكار — الكتب — أسماء الله — أعلام المسلمين',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildResults(AsyncValue<List<Map<String, dynamic>>> quranAsync, AsyncValue<List<SearchResult>> globalAsync) {
    final surahsAsync = ref.watch(surahListProvider);
    final surahs = surahsAsync.valueOrNull ?? [];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      children: [
        if (quranAsync is AsyncData && _query.isNotEmpty)
          _buildQuranSection(quranAsync.valueOrNull ?? [], surahs),
        if (globalAsync is AsyncLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
          ),
        if (globalAsync is AsyncData)
          ..._buildGlobalSections(globalAsync.valueOrNull ?? []),
        if ((quranAsync is AsyncData && (quranAsync.valueOrNull ?? []).isEmpty) &&
            (globalAsync is AsyncData && (globalAsync.valueOrNull ?? []).isEmpty))
          _buildNoResults(),
      ],
    );
  }

  Widget _buildQuranSection(List<Map<String, dynamic>> results, List<SurahMeta> surahs) {
    if (results.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.menu_book, 'القرآن الكريم', AppColors.gold),
        ...results.take(8).map((r) => _quranResultTile(r, surahs)),
        const SizedBox(height: 12),
      ],
    );
  }

  List<Widget> _buildGlobalSections(List<SearchResult> results) {
    if (results.isEmpty) return [];

    final grouped = <String, List<SearchResult>>{};
    for (final r in results) {
      grouped.putIfAbsent(r.type, () => []).add(r);
    }

    final typeMeta = {
      'hadith': {'icon': Icons.chat, 'label': 'الحديث النبوي', 'color': AppColors.goldLight},
      'dua': {'icon': Icons.handshake, 'label': 'الأدعية', 'color': AppColors.success},
      'azkar': {'icon': Icons.self_improvement, 'label': 'الأذكار', 'color': AppColors.gold},
      'book': {'icon': Icons.library_books, 'label': 'الكتب', 'color': AppColors.goldMuted},
      'name': {'icon': Icons.star, 'label': 'أسماء الله الحسنى', 'color': AppColors.goldLight},
      'figure': {'icon': Icons.people, 'label': 'أعلام المسلمين', 'color': const Color(0xFF3F51B5)},
    };

    final widgets = <Widget>[];
    for (final entry in grouped.entries) {
      final type = entry.key;
      final items = entry.value;
      final meta = typeMeta[type] ?? {'icon': Icons.search, 'label': type, 'color': AppColors.goldMuted};
      widgets.add(_sectionHeader(meta['icon'] as IconData, meta['label'] as String, meta['color'] as Color));
      for (final item in items.take(8)) {
        widgets.add(_resultTile(item));
      }
      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

  Widget _sectionHeader(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label,
            style: TextStyle(color: color, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _quranResultTile(Map<String, dynamic> r, List<SurahMeta> surahs) {
    final surahNum = r['surah'] as int? ?? 1;
    final ayahNum = r['ayah'] as int? ?? 1;
    final surah = surahs.where((s) => s.number == surahNum).isNotEmpty
        ? surahs.firstWhere((s) => s.number == surahNum)
        : SurahMeta(number: surahNum, nameArabic: 'سورة $surahNum', nameEnglish: '', nameTransliteration: '', ayahs: 0, revelationType: '', startPage: 0);

    return _resultContainer(
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        leading: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text('$surahNum:$ayahNum',
              style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ),
        title: Text(r['arabic'] as String? ?? '',
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14, height: 1.4)),
        subtitle: Text(r['translation'] as String? ?? '',
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 11)),
        onTap: () => context.push('/surah-reader', extra: {
          'surah': surahNum, 'ayah': ayahNum, 'surahName': surah.nameArabic,
        }),
      ),
    );
  }

  Widget _resultTile(SearchResult item) {
    IconData icon;
    Color color;
    switch (item.type) {
      case 'hadith':
        icon = Icons.chat; color = AppColors.goldLight; break;
      case 'dua':
        icon = Icons.handshake; color = AppColors.success; break;
      case 'azkar':
        icon = Icons.self_improvement; color = AppColors.gold; break;
      case 'book':
        icon = Icons.library_books; color = AppColors.goldMuted; break;
      case 'name':
        icon = Icons.star; color = AppColors.goldLight; break;
      case 'figure':
        icon = Icons.people; color = const Color(0xFF3F51B5); break;
      default:
        icon = Icons.search; color = AppColors.textOnDarkMuted;
    }

    String route;
    Map<String, dynamic>? extras;
    final data = item.extra;
    switch (item.type) {
      case 'hadith':
        route = '/hadith'; extras = null; break;
      case 'dua':
        route = '/dua'; extras = null; break;
      case 'azkar':
        route = '/azkar'; extras = null; break;
      case 'book':
        route = '/book-reader/${data?['id'] ?? 1}'; extras = null; break;
      case 'name':
        route = '/names'; extras = null; break;
      case 'figure':
        route = '/companions'; extras = null; break;
      default:
        route = '/'; extras = null;
    }

    return _resultContainer(
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        leading: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 16),
        ),
        title: Text(item.title,
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14, height: 1.4)),
        subtitle: Text(item.subtitle,
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 11)),
        onTap: extras != null
            ? () => context.push(route, extra: extras)
            : () => context.push(route),
      ),
    );
  }

  Widget _resultContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: child,
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: AppColors.textOnDarkMuted, size: 48),
            const SizedBox(height: 12),
            const Text('لا نتائج',
              style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
            const SizedBox(height: 4),
            Text('لا يوجد نتائج لـ "$_query"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
