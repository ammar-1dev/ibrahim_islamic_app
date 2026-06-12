import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../data/book_model.dart';

class BookReaderScreen extends StatefulWidget {
  final int bookId;

  const BookReaderScreen({super.key, required this.bookId});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final BookRepository _repo = BookRepository();
  Map<String, dynamic>? _bookMeta;
  BookContent? _content;
  bool _loading = true;
  final Set<int> _expandedChapters = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final meta = await _repo.loadBookMeta(widget.bookId);
    final content = await _repo.loadContent(widget.bookId);
    if (mounted) {
      setState(() {
        _bookMeta = meta;
        _content = content;
        _loading = false;
      });
      if (meta != null) {
        recordActivity(
          id: 'book-${widget.bookId}',
          title: meta['title'] as String? ?? 'كتاب',
          subtitle: meta['author'] as String? ?? '',
          route: '/book-reader/${widget.bookId}',
          icon: '📚',
        );
      }
    }
  }

  void _toggleChapter(int index) {
    setState(() {
      if (_expandedChapters.contains(index)) {
        _expandedChapters.remove(index);
      } else {
        _expandedChapters.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: Text(_bookMeta?['title'] as String? ?? 'الكتاب'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _bookMeta == null
              ? const Center(
                  child: Text(
                    'الكتاب غير موجود',
                    style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 18),
                  ),
                )
              : _content == null || _content!.chapters.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book, color: AppColors.goldMuted, size: 64),
                          const SizedBox(height: AppDimensions.lg),
                          const Text(
                            'محتوى هذا الكتاب قيد الإضافة',
                            style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _BookHeader(book: _bookMeta!),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'فهرس الكتاب',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontFamily: 'Amiri',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.sm),
                                const Divider(color: AppColors.goldMuted),
                                const SizedBox(height: AppDimensions.sm),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final chapter = _content!.chapters[index];
                              final expanded = _expandedChapters.contains(index);
                              return _ChapterCard(
                                chapter: chapter,
                                index: index + 1,
                                expanded: expanded,
                                onTap: () => _toggleChapter(index),
                              );
                            },
                            childCount: _content!.chapters.length,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
                      ],
                    ),
    );
  }
}

class _BookHeader extends StatelessWidget {
  final Map<String, dynamic> book;
  const _BookHeader({required this.book});

  IconData _categoryIcon(String category) {
    if (category.contains('تفسير')) return Icons.menu_book;
    if (category.contains('حديث')) return Icons.chat;
    if (category.contains('فقه')) return Icons.balance;
    if (category.contains('عقيدة')) return Icons.star;
    if (category.contains('سيرة') || category.contains('تاريخ')) return Icons.timeline;
    if (category.contains('رقائق') || category.contains('تزكية')) return Icons.self_improvement;
    if (category.contains('أذكار') || category.contains('دعاء')) return Icons.volunteer_activism;
    return Icons.library_books;
  }

  Color _categoryColor(String category) {
    if (category.contains('تفسير')) return const Color(0xFF4CAF50);
    if (category.contains('حديث')) return const Color(0xFFFF9800);
    if (category.contains('فقه')) return const Color(0xFF00BCD4);
    if (category.contains('عقيدة')) return const Color(0xFF9C27B0);
    if (category.contains('سيرة') || category.contains('تاريخ')) return const Color(0xFF2196F3);
    if (category.contains('رقائق') || category.contains('تزكية')) return const Color(0xFFE91E63);
    if (category.contains('أذكار') || category.contains('دعاء')) return const Color(0xFFFF5722);
    return AppColors.gold;
  }

  @override
  Widget build(BuildContext context) {
    final category = (book['category'] as String?) ?? '';
    final era = (book['era'] as String?) ?? '';
    final color = _categoryColor(category);

    return Container(
      margin: const EdgeInsets.all(AppDimensions.lg),
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), AppColors.navyLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Icon(_categoryIcon(category), color: color, size: 36),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            book['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            book['author'] as String,
            style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 14),
          ),
          if (era.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                era,
                style: TextStyle(color: color, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.md),
          Text(
            book['description'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final BookChapter chapter;
  final int index;
  final bool expanded;
  final VoidCallback onTap;

  const _ChapterCard({required this.chapter, required this.index, required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: expanded ? AppColors.gold : AppColors.goldMuted),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: AppColors.goldMuted, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$index',
                        style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(chapter.title,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: expanded ? AppColors.gold : AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.goldMuted, size: 20),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(color: AppColors.goldMuted, height: 1),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: chapter.sections.map((section) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (section.title != null && section.title!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                            child: Text(section.title!,
                              style: const TextStyle(color: AppColors.goldLight, fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        Text(section.text,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 15, height: 2.0)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
