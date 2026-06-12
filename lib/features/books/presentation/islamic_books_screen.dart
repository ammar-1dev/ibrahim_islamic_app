import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';

class IslamicBooksScreen extends StatefulWidget {
  const IslamicBooksScreen({super.key});

  @override
  State<IslamicBooksScreen> createState() => _IslamicBooksScreenState();
}

class _IslamicBooksScreenState extends State<IslamicBooksScreen> {
  List<Map<String, dynamic>> _allBooks = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  List<String> _categories = [];
  String _selectedCategory = 'الكل';
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    final json = await rootBundle.loadString('assets/books/islamic_books.json');
    final list = jsonDecode(json) as List;
    setState(() {
      _allBooks = list.cast<Map<String, dynamic>>();
      _categories = ['الكل', ...{for (final b in _allBooks) b['category'] as String}];
      _filteredBooks = List.from(_allBooks);
      _loaded = true;
    });
  }

  void _onSearch() {
    _applyFilter();
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filteredBooks = _allBooks.where((b) {
        final matchCategory = _selectedCategory == 'الكل' || b['category'] == _selectedCategory;
        if (!matchCategory) return false;
        if (q.isEmpty) return true;
        return (b['title'] as String).toLowerCase().contains(q) ||
               (b['author'] as String).toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        backgroundColor: AppColors.navy,
        appBar: AppBar(
          title: const Text('المكتبة الإسلامية'),
          backgroundColor: AppColors.navy,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('المكتبة الإسلامية'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.lg, 0, AppDimensions.lg, AppDimensions.md),
              child: Column(
                children: [
                  TextField(
                    controller: _searchCtrl,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن كتاب...',
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
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, i) {
                        final selected = _categories[i] == _selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCategory = _categories[i]);
                            _applyFilter();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: AppDimensions.sm),
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.gold : AppColors.navyLight,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                              border: Border.all(color: selected ? AppColors.gold : AppColors.goldMuted),
                            ),
                            child: Text(
                              _categories[i],
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
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: [
                      Text(
                        '${_filteredBooks.length} كتاب',
                        style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Amiri', fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = _filteredBooks[index];
                  final extRoute = book['external_route'] as String?;
                  return _BookCard(
                    book: book,
                      onTap: () {
                      recordActivity(
                        id: 'book-${book['id']}',
                        title: book['title'] as String? ?? 'كتاب',
                        subtitle: book['author'] as String? ?? '',
                        route: extRoute ?? '/book-reader/${book['id']}',
                        icon: '📚',
                      );
                      if (extRoute != null) {
                        context.go(extRoute);
                      } else {
                        context.push('/book-reader/${book['id']}');
                      }
                    },
                  );
                },
                childCount: _filteredBooks.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback onTap;

  const _BookCard({required this.book, required this.onTap});

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
    final category = book['category'] as String;
    final color = _categoryColor(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.goldMuted),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(_categoryIcon(category), color: color, size: 24),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] as String,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book['author'] as String,
                    style: const TextStyle(color: AppColors.goldMuted, fontFamily: 'Inter', fontSize: 12),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    book['description'] as String,
                    style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 13, height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
