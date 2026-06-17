import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../data/story_model.dart';
import '../data/story_repository.dart';

class StoryDetailScreen extends StatefulWidget {
  final int storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final StoryRepository _repo = StoryRepository();
  StoryContent? _story;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final story = await _repo.loadStoryContent(widget.storyId);
      setState(() {
        _story = story;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.textOnDark,
        title: Text(
          _story?.title ?? 'القصة',
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _story == null
              ? const Center(
                  child: Text('القصة غير موجودة', style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri')),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppDimensions.lg),
          ..._story!.sections.map((section) => _buildSection(section)),
          const SizedBox(height: AppDimensions.xl),
          const Center(
            child: Text(
              'والله أعلم',
              style: TextStyle(
                color: AppColors.gold,
                fontFamily: 'Amiri',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyLight, Color(0xFF1A2744)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_stories, size: 48, color: AppColors.gold),
          const SizedBox(height: AppDimensions.sm),
          Text(
            _story!.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontFamily: 'Amiri',
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_story!.subtitle.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.xs),
            Text(
              _story!.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gold.withValues(alpha: 0.8),
                fontFamily: 'Amiri',
                fontSize: 15,
              ),
            ),
          ],
          if (_story!.era.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _story!.era,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Amiri',
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.sm),
          Text(
            _story!.summary,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textOnDark.withValues(alpha: 0.7),
              fontFamily: 'Amiri',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(StorySection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: Text(
              section.title,
              style: const TextStyle(
                color: AppColors.gold,
                fontFamily: 'Amiri',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            section.text,
            style: const TextStyle(
              color: AppColors.textOnDark,
              fontFamily: 'Amiri',
              fontSize: 15,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
