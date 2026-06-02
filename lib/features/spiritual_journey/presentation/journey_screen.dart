import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/storage/local_storage.dart';

enum SpiritualLevel {
  mubtadi(nameAr: 'المبتدئ', requirement: 'الصلوات الخمس منتظمة', emoji: '🌱'),
  taib(nameAr: 'التائب', requirement: 'أذكار الصباح والمساء 30 يوماً', emoji: '🌿'),
  mukhbit(nameAr: 'المخبت', requirement: 'ختم القرآن مرة كاملة', emoji: '🌳'),
  awwab(nameAr: 'الأوّاب', requirement: 'قيام الليل 30 يوماً', emoji: '⭐'),
  zahid(nameAr: 'الزاهد', requirement: 'صدقة يومية 90 يوماً', emoji: '💛'),
  khalil(nameAr: 'الخليل', requirement: 'جميع المستويات مكتملة', emoji: '👑');

  const SpiritualLevel({
    required this.nameAr,
    required this.requirement,
    required this.emoji,
  });

  final String nameAr;
  final String requirement;
  final String emoji;
}

class SpiritualJourneyScreen extends StatefulWidget {
  const SpiritualJourneyScreen({super.key});

  @override
  State<SpiritualJourneyScreen> createState() => _SpiritualJourneyScreenState();
}

class _SpiritualJourneyScreenState extends State<SpiritualJourneyScreen> {
  final _storage = LocalStorage();
  int _currentLevel = 0;

  @override
  void initState() {
    super.initState();
    _currentLevel = _storage.getSpiritualLevel();
  }

  @override
  Widget build(BuildContext context) {
    final levels = SpiritualLevel.values;

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الرحلة الإيمانية'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          children: [
            // Current level badge
            _CurrentLevelBadge(level: levels[_currentLevel.clamp(0, levels.length - 1)]),
            const SizedBox(height: AppDimensions.lg),
            // Overall progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تقدمك الروحي',
                      style: TextStyle(
                        color: AppColors.textOnDark,
                        fontFamily: 'Amiri',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${_currentLevel + 1}/${levels.length}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: (_currentLevel + 1) / levels.length,
                    backgroundColor: AppColors.navyLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),
            // Timeline
            ...List.generate(levels.length, (i) {
              final isDone = i < _currentLevel;
              final isActive = i == _currentLevel;
              final isLocked = i > _currentLevel;
              return _LevelNode(
                level: levels[i],
                index: i,
                isDone: isDone,
                isActive: isActive,
                isLocked: isLocked,
                isLast: i == levels.length - 1,
                onUnlock: isActive
                    ? () {
                        setState(() => _currentLevel++);
                        _storage.saveSpiritualLevel(_currentLevel);
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CurrentLevelBadge extends StatelessWidget {
  final SpiritualLevel level;
  const _CurrentLevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2C4E), Color(0xFF0F1C3A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      child: Row(
        children: [
          Text(level.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: AppDimensions.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مستواك الحالي',
                style: TextStyle(
                  color: AppColors.textOnDarkMuted,
                  fontFamily: 'Inter',
                  fontSize: 12,
                ),
              ),
              Text(
                level.nameAr,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                level.requirement,
                style: const TextStyle(
                  color: AppColors.textOnDarkMuted,
                  fontFamily: 'Amiri',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  final SpiritualLevel level;
  final int index;
  final bool isDone;
  final bool isActive;
  final bool isLocked;
  final bool isLast;
  final VoidCallback? onUnlock;

  const _LevelNode({
    required this.level,
    required this.index,
    required this.isDone,
    required this.isActive,
    required this.isLocked,
    required this.isLast,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    IconData nodeIcon;

    if (isDone) {
      nodeColor = AppColors.success;
      nodeIcon = Icons.check;
    } else if (isActive) {
      nodeColor = AppColors.gold;
      nodeIcon = Icons.timer_outlined;
    } else {
      nodeColor = AppColors.navyLight;
      nodeIcon = Icons.lock_outlined;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDone || isActive ? nodeColor.withOpacity(0.2) : AppColors.navyLight,
                shape: BoxShape.circle,
                border: Border.all(color: nodeColor, width: 2),
              ),
              child: Center(
                child: isDone
                    ? Icon(nodeIcon, color: nodeColor, size: 20)
                    : Text(
                        level.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isDone ? AppColors.success.withOpacity(0.4) : AppColors.goldMuted,
              ),
          ],
        ),
        const SizedBox(width: AppDimensions.md),
        // Level card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.md, top: 4),
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: isActive ? AppColors.goldMuted : AppColors.navyLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: isActive ? AppColors.gold : AppColors.goldMuted,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.nameAr,
                  style: TextStyle(
                    color: isLocked ? AppColors.textOnDarkMuted : AppColors.gold,
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  level.requirement,
                  style: const TextStyle(
                    color: AppColors.textOnDarkMuted,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
                if (isActive && onUnlock != null) ...[
                  const SizedBox(height: AppDimensions.sm),
                  GestureDetector(
                    onTap: onUnlock,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: const Text(
                        'أكملت هذا المستوى ✓',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
