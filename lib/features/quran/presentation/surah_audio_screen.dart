import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/audio_service.dart';
import '../../../../core/utils/quran_audio.dart';

final surahNames = {
  1: 'الفاتحة', 2: 'البقرة', 3: 'آل عمران', 4: 'النساء', 5: 'المائدة',
  6: 'الأنعام', 7: 'الأعراف', 8: 'الأنفال', 9: 'التوبة', 10: 'يونس',
  11: 'هود', 12: 'يوسف', 13: 'الرعد', 14: 'إبراهيم', 15: 'الحجر',
  16: 'النحل', 17: 'الإسراء', 18: 'الكهف', 19: 'مريم', 20: 'طه',
  21: 'الأنبياء', 22: 'الحج', 23: 'المؤمنون', 24: 'النور', 25: 'الفرقان',
  26: 'الشعراء', 27: 'النمل', 28: 'القصص', 29: 'العنكبوت', 30: 'الروم',
  31: 'لقمان', 32: 'السجدة', 33: 'الأحزاب', 34: 'سبأ', 35: 'فاطر',
  36: 'يس', 37: 'الصافات', 38: 'ص', 39: 'الزمر', 40: 'غافر',
  41: 'فصلت', 42: 'الشورى', 43: 'الزخرف', 44: 'الدخان', 45: 'الجاثية',
  46: 'الأحقاف', 47: 'محمد', 48: 'الفتح', 49: 'الحجرات', 50: 'ق',
  51: 'الذاريات', 52: 'الطور', 53: 'النجم', 54: 'القمر', 55: 'الرحمن',
  56: 'الواقعة', 57: 'الحديد', 58: 'المجادلة', 59: 'الحشر', 60: 'الممتحنة',
  61: 'الصف', 62: 'الجمعة', 63: 'المنافقون', 64: 'التغابن', 65: 'الطلاق',
  66: 'التحريم', 67: 'الملك', 68: 'القلم', 69: 'الحاقة', 70: 'المعارج',
  71: 'نوح', 72: 'الجن', 73: 'المزمل', 74: 'المدثر', 75: 'القيامة',
  76: 'الإنسان', 77: 'المرسلات', 78: 'النبأ', 79: 'النازعات', 80: 'عبس',
  81: 'التكوير', 82: 'الانفطار', 83: 'المطففين', 84: 'الانشقاق', 85: 'البروج',
  86: 'الطارق', 87: 'الأعلى', 88: 'الغاشية', 89: 'الفجر', 90: 'البلد',
  91: 'الشمس', 92: 'الليل', 93: 'الضحى', 94: 'الشرح', 95: 'التين',
  96: 'العلق', 97: 'القدر', 98: 'البينة', 99: 'الزلزلة', 100: 'العاديات',
  101: 'القارعة', 102: 'التكاثر', 103: 'العصر', 104: 'الهمزة', 105: 'الفيل',
  106: 'قريش', 107: 'الماعون', 108: 'الكوثر', 109: 'الكافرون', 110: 'النصر',
  111: 'المسد', 112: 'الإخلاص', 113: 'الفلق', 114: 'الناس',
};

class SurahAudioScreen extends ConsumerStatefulWidget {
  const SurahAudioScreen({super.key});

  @override
  ConsumerState<SurahAudioScreen> createState() => _SurahAudioScreenState();
}

class _SurahAudioScreenState extends ConsumerState<SurahAudioScreen> {
  int? _currentSurah;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    ref.read(audioServiceProvider).positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    ref.read(audioServiceProvider).durationStream.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    ref.read(audioServiceProvider).stateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });
  }

  Future<void> _playSurah(int number) async {
    setState(() => _currentSurah = number);
    await ref.read(audioServiceProvider).play(QuranAudio.getSurahUrl(number));
  }

  Future<void> _togglePlay() async {
    final audio = ref.read(audioServiceProvider);
    if (_isPlaying) {
      await audio.pause();
    } else {
      await audio.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('استماع القرآن'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_currentSurah != null) _buildPlayerBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.lg),
              itemCount: surahNames.length,
              itemBuilder: (context, index) {
                final number = index + 1;
                final name = surahNames[number]!;
                final isCurrent = _currentSurah == number;
                return GestureDetector(
                  onTap: () => _playSurah(number),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.goldMuted : AppColors.navyLight,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: isCurrent ? AppColors.gold : AppColors.goldMuted),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.gold : AppColors.goldMuted,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('$number',
                              style: TextStyle(
                                color: isCurrent ? AppColors.navy : AppColors.gold,
                                fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Text(name,
                            style: TextStyle(
                              color: isCurrent ? AppColors.gold : AppColors.textOnDark,
                              fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                        Icon(
                          isCurrent && _isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: isCurrent ? AppColors.gold : AppColors.textOnDarkMuted,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar() {
    final surahName = _currentSurah != null ? surahNames[_currentSurah!] : '';
    final pos = _position;
    final dur = _duration ?? Duration.zero;
    final progress = dur.inSeconds > 0 ? pos.inSeconds / dur.inSeconds : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: const BoxDecoration(
        color: AppColors.navyLight,
        border: Border(top: BorderSide(color: AppColors.goldMuted)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(surahName ?? '', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.goldMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(pos), style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(_volume > 0 ? Icons.volume_up : Icons.volume_off, color: AppColors.gold, size: 18),
                    onPressed: () {
                      _volume = _volume > 0 ? 0 : 1.0;
                      ref.read(audioServiceProvider).setVolume(_volume);
                    },
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.gold, size: 28),
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, color: AppColors.gold, size: 18),
                    onPressed: () => ref.read(audioServiceProvider).stop(),
                  ),
                ],
              ),
              Text(_formatDuration(dur), style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }
}
