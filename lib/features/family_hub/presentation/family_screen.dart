import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class FamilyHubScreen extends StatelessWidget {
  const FamilyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('ملتقى العائلة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFamilyStats(),
            const SizedBox(height: AppDimensions.xl),
            const Text(
              'تحديات العائلة',
              style: TextStyle(
                color: AppColors.gold,
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            _buildChallengeCard(
              title: 'ختمة جماعية',
              description: 'نقرأ سورة البقرة معاً هذا الأسبوع',
              progress: 0.6,
              participants: 4,
            ),
            const SizedBox(height: AppDimensions.md),
            _buildChallengeCard(
              title: 'صلاة الفجر في المسجد',
              description: 'تحدي الاستيقاظ المبكر لجميع أفراد المنزل',
              progress: 0.8,
              participants: 3,
            ),
            const SizedBox(height: AppDimensions.xl),
            const Text(
              'أفراد العائلة',
              style: TextStyle(
                color: AppColors.gold,
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            _buildFamilyMember(name: 'أحمد (أنت)', level: 'مخبت', isMe: true),
            _buildFamilyMember(name: 'سارة', level: 'تائبة', isMe: false),
            _buildFamilyMember(name: 'عمر', level: 'مبتدئ', isMe: false),
            const SizedBox(height: AppDimensions.xxl),
            _buildAddMemberButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navyLight, Color(0xFF1E3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        children: [
          const Text(
            'نقاط العائلة هذا الشهر',
            style: TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Inter',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          const Text(
            '١,٢٥٠',
            style: TextStyle(
              color: AppColors.gold,
              fontFamily: 'Inter',
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الترتيب', 'الأول'),
              _buildStatItem('التحديات', '٥'),
              _buildStatItem('الأعضاء', '٣'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textOnDarkMuted,
            fontFamily: 'Amiri',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required double progress,
    required int participants,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: List.generate(
                  participants,
                  (index) => Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 1),
                    ),
                    child: const Icon(Icons.person, size: 14, color: AppColors.gold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textOnDarkMuted,
              fontFamily: 'Amiri',
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.gold.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMember({
    required String name,
    required String level,
    required bool isMe,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
      decoration: BoxDecoration(
        color: isMe ? AppColors.goldMuted : AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isMe ? AppColors.gold : AppColors.goldMuted),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.gold.withOpacity(0.2),
            child: Text(name[0], style: const TextStyle(color: AppColors.gold)),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'المستوى: $level',
                  style: const TextStyle(
                    color: AppColors.textOnDarkMuted,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: AppColors.gold, size: 20),
        ],
      ),
    );
  }

  Widget _buildAddMemberButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: AppColors.gold),
        label: const Text(
          'إضافة فرد جديد للعائلة',
          style: TextStyle(
            color: AppColors.gold,
            fontFamily: 'Amiri',
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
