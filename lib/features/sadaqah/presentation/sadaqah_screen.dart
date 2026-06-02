import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

final sadaqahLogProvider = StateNotifierProvider<SadaqahLogNotifier, List<SadaqahEntry>>((ref) {
  return SadaqahLogNotifier();
});

class SadaqahEntry {
  final double amount;
  final String type;
  final DateTime date;
  const SadaqahEntry({required this.amount, required this.type, required this.date});
}

class SadaqahLogNotifier extends StateNotifier<List<SadaqahEntry>> {
  SadaqahLogNotifier() : super([]);

  void add(double amount, String type) {
    state = [...state, SadaqahEntry(amount: amount, type: type, date: DateTime.now())];
  }

  double get total => state.fold(0.0, (sum, e) => sum + e.amount);
  int get count => state.length;
}

class SadaqahScreen extends ConsumerStatefulWidget {
  const SadaqahScreen({super.key});

  @override
  ConsumerState<SadaqahScreen> createState() => _SadaqahScreenState();
}

class _SadaqahScreenState extends ConsumerState<SadaqahScreen> {
  final _amountCtrl = TextEditingController();
  String _selectedType = 'صدقة';

  final List<String> _types = ['صدقة', 'زكاة', 'كفارة', 'تبرع'];

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final log = ref.watch(sadaqahLogProvider);
    final notifier = ref.read(sadaqahLogProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('تتبع الصدقة'),
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
                  const Text('إجمالي الصدقات', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
                  const SizedBox(height: AppDimensions.sm),
                  Text('\$${notifier.total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w900)),
                  Text('${notifier.count} مرة', style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            const Text('إضافة جديدة', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: _types.map((t) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: _selectedType == t ? AppColors.gold : AppColors.navyLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(color: _selectedType == t ? AppColors.gold : AppColors.goldMuted),
                      ),
                      child: Text(t, textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedType == t ? AppColors.navy : AppColors.textOnDark,
                          fontFamily: 'Amiri', fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: AppDimensions.md),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: const TextStyle(color: AppColors.textOnDarkMuted),
                filled: true, fillColor: AppColors.navyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountCtrl.text);
                  if (amount != null && amount > 0) {
                    notifier.add(amount, _selectedType);
                    _amountCtrl.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
                ),
                child: const Text('إضافة', style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            if (log.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.xl),
              const Divider(color: AppColors.goldMuted),
              const SizedBox(height: AppDimensions.md),
              ...log.reversed.map((e) => Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.navyLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.goldMuted),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.type, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 14)),
                    Text('\$${e.amount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
