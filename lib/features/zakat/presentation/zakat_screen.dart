import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final TextEditingController _cashCtrl = TextEditingController();
  final TextEditingController _goldCtrl = TextEditingController();
  final TextEditingController _silverCtrl = TextEditingController();
  final TextEditingController _stocksCtrl = TextEditingController();

  double _totalZakat = 0;
  bool _calculated = false;

  // Rough estimates for Nisab (should ideally be fetched from an API)
  final double _goldPrice = 75.0; // USD per gram
  final double _nisabGoldGrams = 85.0;

  void _calculateZakat() {
    final cash = double.tryParse(_cashCtrl.text) ?? 0;
    final goldValue = (double.tryParse(_goldCtrl.text) ?? 0) * _goldPrice;
    final silverValue = (double.tryParse(_silverCtrl.text) ?? 0) * 0.8; // Rough silver price
    final stocks = double.tryParse(_stocksCtrl.text) ?? 0;

    final totalWealth = cash + goldValue + silverValue + stocks;
    final nisabValue = _goldPrice * _nisabGoldGrams;

    setState(() {
      if (totalWealth >= nisabValue) {
        _totalZakat = totalWealth * 0.025; // 2.5%
      } else {
        _totalZakat = 0;
      }
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('حاسبة الزكاة'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: AppDimensions.lg),
            _buildInputSection(),
            const SizedBox(height: AppDimensions.xl),
            if (_calculated) _buildResultCard(),
            const SizedBox(height: AppDimensions.xl),
            ElevatedButton(
              onPressed: _calculateZakat,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
              ),
              child: const Text('احسب الزكاة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Amiri')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.gold),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'الزكاة هي 2.5% من إجمالي الثروة إذا بلغت النصاب وحال عليها الحول.',
              style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        _buildTextField(_cashCtrl, 'النقد والمدخرات', '0.00', Icons.money),
        const SizedBox(height: AppDimensions.md),
        _buildTextField(_goldCtrl, 'ذهب (بالجرام)', '0', Icons.brightness_high),
        const SizedBox(height: AppDimensions.md),
        _buildTextField(_silverCtrl, 'فضة (بالجرام)', '0', Icons.brightness_medium),
        const SizedBox(height: AppDimensions.md),
        _buildTextField(_stocksCtrl, 'الأسهم والاستثمارات', '0.00', Icons.trending_up),
      ],
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      style: const TextStyle(color: AppColors.textOnDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri'),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textOnDarkMuted),
        prefixIcon: Icon(icon, color: AppColors.goldMuted),
        filled: true,
        fillColor: AppColors.navyLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.goldMuted),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldLight, AppColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: const [
          BoxShadow(color: AppColors.goldMuted, blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'مبلغ الزكاة المستحق',
            style: TextStyle(color: AppColors.navy, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_totalZakat.toStringAsFixed(2)}',
            style: const TextStyle(color: AppColors.navy, fontSize: 36, fontWeight: FontWeight.w900, fontFamily: 'Inter'),
          ),
          if (_totalZakat == 0)
            const Text(
              'لم يبلغ مالك النصاب الشرعي بعد.',
              style: TextStyle(color: AppColors.navy, fontFamily: 'Amiri', fontSize: 14),
            ),
        ],
      ),
    );
  }
}
