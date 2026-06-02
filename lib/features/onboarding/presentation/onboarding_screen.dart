import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/storage/local_storage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      icon: Icons.mosque,
      title: 'مرحباً بك في إبراهيم',
      description: 'مرافقك الروحي اليومي — كل ما تحتاجه لرحلة إيمانية متكاملة في تطبيق واحد.',
    ),
    _OnboardingStep(
      icon: Icons.access_time,
      title: 'مواقيت الصلاة',
      description: 'تتبع أوقات الصلاة بدقة مع إشعارات مخصصة، واتجاه القبلة في أي مكان.',
    ),
    _OnboardingStep(
      icon: Icons.menu_book,
      title: 'القرآن الكريم',
      description: 'اقرأ المصحف كاملاً، استمع للتلاوة، وتابع آياتك مع التفسير والإشارات.',
    ),
    _OnboardingStep(
      icon: Icons.auto_stories,
      title: 'أذكار وأدعية',
      description: 'أذكار الصباح والمساء، أدعية متنوعة تناسب حالتك، وتسبيح ذكي.',
    ),
  ];

  void _onDone() {
    final storage = LocalStorage();
    storage.saveBool('onboarding_done', true);
    context.go('/');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _steps.length,
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.goldMuted,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: Icon(step.icon, color: AppColors.gold, size: 56),
                        ),
                        const SizedBox(height: AppDimensions.xxl),
                        Text(step.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 28, fontWeight: FontWeight.w700)),
                        const SizedBox(height: AppDimensions.lg),
                        Text(step.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 18, height: 1.8)),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_steps.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i ? AppColors.gold : AppColors.goldMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
            const SizedBox(height: AppDimensions.xl),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onDone,
                    child: const Text('تخطي', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _steps.length - 1) {
                        _onDone();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl, vertical: AppDimensions.md),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
                    ),
                    child: Text(
                      _currentPage == _steps.length - 1 ? 'ابدأ الرحلة' : 'التالي',
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final IconData icon;
  final String title;
  final String description;
  const _OnboardingStep({required this.icon, required this.title, required this.description});
}
