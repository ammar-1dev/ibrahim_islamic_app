import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class IbrahimScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const IbrahimScaffold({super.key, required this.child});

  @override
  ConsumerState<IbrahimScaffold> createState() => _IbrahimScaffoldState();
}

class _IbrahimScaffoldState extends ConsumerState<IbrahimScaffold> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    ref.read(currentTabProvider.notifier).state = index;
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/quran'); break;
      case 2: break;
      case 3: context.go('/explore'); break;
      case 4: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            currentIndex: ref.watch(currentTabProvider),
            onTap: (index) {
              if (index != 2) {
                _onTabTapped(index);
              } else {
                context.push('/ai-assistant');
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.home_ar,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: AppStrings.quran_ar,
              ),
              BottomNavigationBarItem(
                icon: SizedBox(width: AppDimensions.aiButtonSize),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: AppStrings.explore_ar,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: AppStrings.profile_ar,
              ),
            ],
          ),
          Positioned(
            bottom: 12,
            child: GestureDetector(
              onTap: () => context.push('/ai-assistant'),
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppDimensions.aiButtonSize,
                      height: AppDimensions.aiButtonSize,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 3.0),
                        boxShadow: const [
                          BoxShadow(color: AppColors.goldMuted, blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.mosque, color: AppColors.gold, size: 24),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.aiAssistant_ar,
                      style: TextStyle(color: AppColors.gold, fontSize: 9, fontFamily: 'Inter', fontWeight: FontWeight.w600),
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
