import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/story_model.dart';
import '../data/story_repository.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final StoryRepository _repo = StoryRepository();
  final TextEditingController _searchCtrl = TextEditingController();
  List<StoryInfo> _allStories = [];
  List<StoryInfo> _filtered = [];
  String _selectedCategory = 'all';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final stories = await _repo.loadStoriesMeta();
      setState(() {
        _allStories = stories;
        _filtered = stories;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = _allStories.where((s) {
        if (_selectedCategory != 'all' && s.category != _selectedCategory) return false;
        if (query.isNotEmpty) {
          return s.title.contains(query) || s.subtitle.contains(query) || s.summary.contains(query);
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.textOnDark,
        title: const Text('قصص إسلامية', style: TextStyle(fontFamily: 'Amiri', fontSize: 20)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => _applyFilter(),
        style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri'),
        decoration: InputDecoration(
          hintText: 'ابحث عن قصة...',
          hintStyle: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.5), fontFamily: 'Amiri'),
          prefixIcon: const Icon(Icons.search, color: AppColors.gold),
          filled: true,
          fillColor: AppColors.navyLight,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        itemCount: storyCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final cat = storyCategories[index];
          final selected = _selectedCategory == cat.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat.id);
              _applyFilter();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? cat.color : AppColors.navyLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? cat.color : cat.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat.icon, size: 16, color: selected ? Colors.white : cat.color),
                  const SizedBox(width: 6),
                  Text(
                    cat.name,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textOnDark,
                      fontFamily: 'Amiri',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    }

    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories, size: 64, color: AppColors.textOnDark.withValues(alpha: 0.3)),
            const SizedBox(height: AppDimensions.md),
            Text(
              'لا توجد قصص تطابق بحثك',
              style: TextStyle(color: AppColors.textOnDark.withValues(alpha: 0.6), fontFamily: 'Amiri', fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.sm),
      itemBuilder: (context, index) {
        final story = _filtered[index];
        return _StoryCard(story: story, onTap: () => context.push('/stories/${story.id}'));
      },
    );
  }
}

class _StoryCard extends StatelessWidget {
  final StoryInfo story;
  final VoidCallback onTap;

  const _StoryCard({required this.story, required this.onTap});

  Color _catColor() {
    for (final c in storyCategories) {
      if (c.id == story.category) return c.color;
    }
    return AppColors.gold;
  }

  @override
  Widget build(BuildContext context) {
    final color = _catColor();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(Icons.auto_stories, color: color, size: 26),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      color: AppColors.textOnDark,
                      fontFamily: 'Amiri',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (story.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      story.subtitle,
                      style: TextStyle(
                        color: AppColors.gold.withValues(alpha: 0.8),
                        fontFamily: 'Amiri',
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    story.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textOnDark.withValues(alpha: 0.6),
                      fontFamily: 'Amiri',
                      fontSize: 12,
                    ),
                  ),
                  if (story.era.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: AppColors.gold.withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Text(
                          story.era,
                          style: TextStyle(
                            color: AppColors.gold.withValues(alpha: 0.6),
                            fontFamily: 'Amiri',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_left, color: color.withValues(alpha: 0.6), size: 20),
          ],
        ),
      ),
    );
  }
}
