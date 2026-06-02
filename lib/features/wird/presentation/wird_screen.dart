import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

final wirdProvider = StateNotifierProvider<WirdNotifier, List<WirdItem>>((ref) {
  return WirdNotifier();
});

class WirdItem {
  final String id;
  final String name;
  final String description;
  bool isDone;

  WirdItem({required this.id, required this.name, required this.description, this.isDone = false});
}

class WirdNotifier extends StateNotifier<List<WirdItem>> {
  WirdNotifier() : super(_defaultItems);

  static final List<WirdItem> _defaultItems = [
    WirdItem(id: '1', name: 'الصلوات الخمس', description: 'أداء الصلوات في أوقاتها'),
    WirdItem(id: '2', name: 'الورد القرآني', description: 'قراءة ورد من القرآن الكريم'),
    WirdItem(id: '3', name: 'أذكار الصباح', description: 'أذكار بداية اليوم'),
    WirdItem(id: '4', name: 'أذكار المساء', description: 'أذكار نهاية اليوم'),
    WirdItem(id: '5', name: 'الأدعية', description: 'الدعاء والذكر'),
    WirdItem(id: '6', name: 'صدقة', description: 'الصدقة ولو بالقليل'),
  ];

  void toggle(String id) {
    state = state.map((w) => w.id == id ? WirdItem(id: w.id, name: w.name, description: w.description, isDone: !w.isDone) : w).toList();
  }

  int get completedCount => state.where((w) => w.isDone).length;
  double get progress => state.isEmpty ? 0 : completedCount / state.length;
}

class WirdScreen extends ConsumerWidget {
  const WirdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wird = ref.watch(wirdProvider);
    final notifier = ref.read(wirdProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('الورد اليومي'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.navyLight, Color(0xFF1E3A6E)]),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(color: AppColors.goldMuted),
              ),
              child: Column(
                children: [
                  const Text('تقدمك اليوم', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
                  const SizedBox(height: AppDimensions.sm),
                  Text('${notifier.completedCount}/${wird.length}', style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w900)),
                  const SizedBox(height: AppDimensions.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    child: LinearProgressIndicator(
                      value: notifier.progress,
                      backgroundColor: AppColors.goldMuted,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            ...wird.map((item) => GestureDetector(
              onTap: () => notifier.toggle(item.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: item.isDone ? AppColors.success.withOpacity(0.1) : AppColors.navyLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: item.isDone ? AppColors.success.withOpacity(0.4) : AppColors.goldMuted),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: item.isDone ? AppColors.success : AppColors.textOnDarkMuted,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                            style: TextStyle(
                              color: item.isDone ? AppColors.textOnDarkMuted : AppColors.textOnDark,
                              fontFamily: 'Amiri', fontSize: 18,
                              decoration: item.isDone ? TextDecoration.lineThrough : null,
                            )),
                          Text(item.description,
                            style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
