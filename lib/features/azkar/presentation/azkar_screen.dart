import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/recent_activity_service.dart';
import '../data/azkar_audio_service.dart';
import '../data/mishari_audio_service.dart';

class Zikr {
  final int id;
  final String arabic;
  final String translation;
  final int count;
  final String source;
  final String category;
  final String benefits;

  const Zikr({
    required this.id,
    required this.arabic,
    required this.translation,
    required this.count,
    required this.source,
    required this.category,
    required this.benefits,
  });

  factory Zikr.fromJson(Map<String, dynamic> json) => Zikr(
        id: json['id'] as int,
        arabic: json['arabic'] as String,
        translation: json['translation'] as String,
        count: json['count'] as int,
        source: json['source'] as String,
        category: json['category'] as String,
        benefits: json['benefits'] as String,
      );
}

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({super.key});

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Zikr> _morning = [];
  List<Zikr> _evening = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    recordActivity(id: 'azkar', title: 'الأذكار', subtitle: 'أذكار الصباح والمساء', route: '/azkar', icon: '🌅');
    _loadAzkar();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAzkar() async {
    final str = await rootBundle.loadString('assets/azkar/azkar.json');
    final data = json.decode(str) as Map<String, dynamic>;
    setState(() {
      _morning = (data['morning'] as List).map((e) => Zikr.fromJson(e as Map<String, dynamic>)).toList();
      _evening = (data['evening'] as List).map((e) => Zikr.fromJson(e as Map<String, dynamic>)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _tabController.index == 0 ? _morning : _evening;

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الأذكار'),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          if (!_loading && currentList.isNotEmpty)
            Consumer(
              builder: (context, ref, _) {
                final mishari = ref.watch(mishariAzkarAudioProvider);
                final playing = mishari.isPlaying;
                return IconButton(
                  icon: Icon(
                    playing ? Icons.stop_rounded : Icons.play_circle_fill_rounded,
                    color: AppColors.gold,
                  ),
                  tooltip: playing ? 'إيقاف' : 'تشغيل الكل',
                  onPressed: () {
                    if (playing) {
                      mishari.stop();
                    } else {
                      _playAll(ref, currentList);
                    }
                  },
                );
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textOnDarkMuted,
          labelStyle: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
          tabs: const [
            Tab(text: 'أذكار الصباح'),
            Tab(text: 'أذكار المساء'),
          ],
          onTap: (_) { ref.read(azkarAudioServiceProvider).stop(); ref.read(mishariAzkarAudioProvider).stop(); },
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _ZikrList(azkar: _morning, category: 'morning'),
                    _ZikrList(azkar: _evening, category: 'evening'),
                  ],
                ),
                _MiniPlayer(currentList: currentList),
              ],
            ),
    );
  }

  void _playAll(WidgetRef ref, List<Zikr> azkar) {
    final mishari = ref.read(mishariAzkarAudioProvider);
    ref.read(azkarAudioServiceProvider).stop();
    if (_tabController.index == 0) {
      mishari.playMorning(totalAthkar: azkar.length);
    } else {
      mishari.playEvening(totalAthkar: azkar.length);
    }
  }
}

class _MiniPlayer extends ConsumerWidget {
  final List<Zikr> currentList;
  const _MiniPlayer({required this.currentList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mishari = ref.watch(mishariAzkarAudioProvider);
    if (!mishari.isPlaying && !mishari.isPaused) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: AppDimensions.md,
          right: AppDimensions.md,
          top: AppDimensions.sm,
          bottom: MediaQuery.of(context).padding.bottom + AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.navyLight,
          border: const Border(top: BorderSide(color: AppColors.goldMuted)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بصوت مشاري بن راشد',
                    style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 11),
                  ),
                  Text(
                    '${currentList.length} ذكر',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            IconButton(
              icon: Icon(
                mishari.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: AppColors.gold, size: 28,
              ),
              onPressed: () => mishari.togglePause(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              icon: const Icon(Icons.stop_rounded, color: AppColors.textOnDarkMuted, size: 22),
              onPressed: () => mishari.stop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZikrList extends StatelessWidget {
  final List<Zikr> azkar;
  final String category;
  const _ZikrList({required this.azkar, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.lg,
        bottom: 80,
      ),
      itemCount: azkar.length,
      itemBuilder: (context, index) => _ZikrCard(zikr: azkar[index], index: index),
    );
  }
}

class _ZikrCard extends ConsumerStatefulWidget {
  final Zikr zikr;
  final int index;
  const _ZikrCard({required this.zikr, required this.index});

  @override
  ConsumerState<_ZikrCard> createState() => _ZikrCardState();
}

class _ZikrCardState extends ConsumerState<_ZikrCard> {
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.zikr.count;
  }

  void _tap() {
    if (_remaining > 0) {
      setState(() => _remaining--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = _remaining == 0;
    final mishari = ref.watch(mishariAzkarAudioProvider);
    final isCurrentTrack = mishari.isPlaying;

    return GestureDetector(
      onTap: _tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: isCurrentTrack
              ? AppColors.success.withValues(alpha: 0.15)
              : done ? AppColors.success.withValues(alpha: 0.1) : AppColors.navyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isCurrentTrack
                ? AppColors.success
                : done ? AppColors.success.withValues(alpha: 0.5) : AppColors.goldMuted,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.zikr.arabic,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: done ? AppColors.textOnDarkMuted : AppColors.gold,
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      height: 2.0,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                GestureDetector(
                  onTap: () {
                    if (isCurrentTrack) {
                      mishari.stop();
                    } else {
                      ref.read(azkarAudioServiceProvider).stop();
                      if (widget.zikr.category == 'morning') {
                        mishari.playMorning();
                      } else {
                        mishari.playEvening();
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrentTrack
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.goldMuted.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Icon(
                      isCurrentTrack && mishari.isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.play_arrow_rounded,
                      color: isCurrentTrack ? AppColors.success : AppColors.gold,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.zikr.source,
                  style: const TextStyle(
                    color: AppColors.textOnDarkMuted,
                    fontFamily: 'Inter',
                    fontSize: 11,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: done ? AppColors.success : AppColors.goldMuted,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    done ? '✓' : '$_remaining/${widget.zikr.count}',
                    style: TextStyle(
                      color: done ? AppColors.white : AppColors.gold,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
}
