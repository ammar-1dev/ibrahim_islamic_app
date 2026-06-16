import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../data/hadith_repository.dart';

class HadithScreen extends StatefulWidget {
  final int collectionId;
  const HadithScreen({super.key, this.collectionId = 1});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final HadithRepository _repo = HadithRepository();
  HadithCollection? _collection;
  bool _loading = true;
  int? _expandedChapterId;
  int? _expandedHadithId;

  @override
  void initState() {
    super.initState();
    recordActivity(
      id: 'hadith_${widget.collectionId}',
      title: 'الأحاديث النبوية',
      subtitle: HadithRepository.getCollectionInfo(widget.collectionId)?.name ?? '',
      route: '/hadith/${widget.collectionId}',
      icon: '📿',
    );
    _load();
  }

  Future<void> _load() async {
    final c = await _repo.load(widget.collectionId);
    setState(() {
      _collection = c;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = HadithRepository.getCollectionInfo(widget.collectionId);
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: Text(info?.name ?? 'الأحاديث'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _collection!.chapters.isEmpty
              ? _buildFlatList()
              : _buildChaptersList(),
    );
  }

  Widget _buildFlatList() {
    final hadiths = _collection!.hadiths;
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.lg),
      itemCount: hadiths.length,
      itemBuilder: (context, i) => _HadithCard(
        hadith: hadiths[i],
        expanded: _expandedHadithId == hadiths[i].id,
        onToggle: () {
          setState(() {
            _expandedHadithId =
                _expandedHadithId == hadiths[i].id ? null : hadiths[i].id;
          });
        },
      ),
    );
  }

  Widget _buildChaptersList() {
    final collection = _collection!;
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.lg),
      itemCount: collection.chapters.length,
      itemBuilder: (context, i) {
        final chapter = collection.chapters[i];
        final isExpanded = _expandedChapterId == chapter.id;
        final chapterHadiths = collection.hadithsInChapter(chapter.id);
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.navyLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.goldMuted),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedChapterId = isExpanded ? null : chapter.id;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldMuted.withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          '${chapterHadiths.length}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.arabic,
                              style: const TextStyle(
                                color: AppColors.textOnDark,
                                fontFamily: 'Amiri',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (chapter.english.isNotEmpty)
                              Text(
                                chapter.english,
                                style: const TextStyle(
                                  color: AppColors.textOnDarkMuted,
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: AppColors.goldMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) ...[
                const Divider(color: AppColors.goldMuted, height: 1),
                ...chapterHadiths.map((h) => _HadithCard(
                      hadith: h,
                      expanded: _expandedHadithId == h.id,
                      onToggle: () {
                        setState(() {
                          _expandedHadithId =
                              _expandedHadithId == h.id ? null : h.id;
                        });
                      },
                      compact: true,
                    )),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HadithCard extends StatefulWidget {
  final HadithEntry hadith;
  final bool expanded;
  final VoidCallback onToggle;
  final bool compact;

  const _HadithCard({
    required this.hadith,
    required this.expanded,
    required this.onToggle,
    this.compact = false,
  });

  @override
  State<_HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<_HadithCard> {
  @override
  Widget build(BuildContext context) {
    final h = widget.hadith;
    final margin = widget.compact
        ? const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 4)
        : const EdgeInsets.only(bottom: AppDimensions.lg);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: widget.compact ? AppColors.navy : AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldMuted,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  'الحديث ${h.number}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  h.source,
                  style: const TextStyle(
                    color: AppColors.goldMuted,
                    fontFamily: 'Inter',
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border:
                  Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (h.narrator.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: Text(
                      h.narrator.contains('رضي الله')
                          ? 'عَنْ ${h.narrator} قَالَ:'
                          : 'عَنْ ${h.narrator} قَالَ:',
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Text(
                  '«${h.fullArabic.replaceAll('"', '').replaceAll('"', '')}»',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    height: 2.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          if (widget.expanded && h.translation.isNotEmpty) ...[
            const Divider(color: AppColors.goldMuted),
            const SizedBox(height: AppDimensions.sm),
            Text(
              h.translation,
              style: const TextStyle(
                color: AppColors.textOnDarkMuted,
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
          ],
          if (h.translation.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: widget.onToggle,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(color: AppColors.goldMuted),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.expanded ? 'إخفاء الترجمة' : 'عرض الترجمة',
                        style: const TextStyle(
                          color: AppColors.goldMuted,
                          fontFamily: 'Amiri',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        widget.expanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: AppColors.goldMuted,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
