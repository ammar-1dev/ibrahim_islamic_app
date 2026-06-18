import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
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

enum RepeatMode {
  none,
  one,
  all,
}

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
  double _speed = 1.0;
  String _reciterCode = 'afs';
  RepeatMode _repeatMode = RepeatMode.none;

  int? _sleepTimerMinutes;
  Timer? _sleepTimer;

  StreamSubscription<ProcessingState>? _processingSub;

  @override
  void initState() {
    super.initState();
    final audio = ref.read(audioServiceProvider);
    audio.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    audio.durationStream.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    audio.stateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });
    _processingSub = audio.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && _currentSurah != null) {
        _onSurahComplete();
      }
    });
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _processingSub?.cancel();
    super.dispose();
  }

  void _onSurahComplete() {
    if (_repeatMode == RepeatMode.one) {
      _playSurah(_currentSurah!);
      return;
    }
    if (_sleepTimerMinutes == 0) {
      _cancelSleepTimer();
      return;
    }
    final next = _currentSurah! + 1;
    if (next > 114) {
      if (_repeatMode == RepeatMode.all) {
        _playSurah(1);
      }
      return;
    }
    _playSurah(next);
  }

  Future<void> _playSurah(int number) async {
    if (_sleepTimerMinutes == 0) {
      _cancelSleepTimer();
      return;
    }
    setState(() => _currentSurah = number);
    final audio = ref.read(audioServiceProvider);
    await audio.play(
      QuranAudio.getSurahUrl(number, reciterCode: _reciterCode),
      surahNumber: number,
      surahName: surahNames[number],
      reciterName: _reciterName(),
      reciterCode: _reciterCode,
    );
    if (audio.speed != _speed) {
      await audio.setSpeed(_speed);
    }
  }

  Future<void> _togglePlay() async {
    final audio = ref.read(audioServiceProvider);
    if (_isPlaying) {
      await audio.pause();
    } else {
      await audio.resume();
    }
  }

  Future<void> _nextSurah() async {
    if (_currentSurah == null) return;
    final next = _currentSurah! >= 114 ? 1 : _currentSurah! + 1;
    await _playSurah(next);
  }

  Future<void> _prevSurah() async {
    if (_currentSurah == null) return;
    final prev = _currentSurah! <= 1 ? 114 : _currentSurah! - 1;
    await _playSurah(prev);
  }

  void _startSleepTimer(int? minutes) {
    _sleepTimer?.cancel();
    setState(() {
      _sleepTimerMinutes = minutes;
    });
    if (minutes == null || minutes <= 0) return;
    if (minutes == 0) return;
    _sleepTimer = Timer(Duration(minutes: minutes), () {
      if (!mounted) return;
      ref.read(audioServiceProvider).stop();
      setState(() {
        _sleepTimerMinutes = null;
        _isPlaying = false;
      });
    });
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    setState(() => _sleepTimerMinutes = null);
  }

  String _sleepTimerLabel() {
    if (_sleepTimerMinutes == null) return 'مؤقت';
    if (_sleepTimerMinutes == 0) return 'بعد السورة';
    return '$_sleepTimerMinutes د';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('استماع القرآن'),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => _showReciterPicker(context),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(_reciterName(), style: const TextStyle(color: Colors.white70, fontFamily: 'Amiri', fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.md, AppDimensions.md, AppDimensions.sm),
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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(pos), style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
              Text(_formatDuration(dur), style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconButton(Icons.skip_previous, _prevSurah),
              const SizedBox(width: 4),
              _iconButton(Icons.replay_10, () => _seekRelative(-10)),
              const SizedBox(width: 12),
              _iconButton(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, _togglePlay, size: 36),
              const SizedBox(width: 12),
              _iconButton(Icons.forward_10, () => _seekRelative(10)),
              const SizedBox(width: 4),
              _iconButton(Icons.skip_next, _nextSurah),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSleepTimerButton(),
              _buildSpeedButton(),
              _buildRepeatButton(),
              _buildVolumeButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed, {double size = 24}) {
    return IconButton(
      icon: Icon(icon, color: AppColors.gold, size: size),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }

  Future<void> _seekRelative(int seconds) async {
    final audio = ref.read(audioServiceProvider);
    final newPos = _position + Duration(seconds: seconds);
    await audio.seek(Duration(seconds: newPos.inSeconds.clamp(0, _duration?.inSeconds ?? 0)));
  }

  Widget _buildVolumeButton() {
    return GestureDetector(
      onTap: () {
        _volume = _volume > 0 ? 0 : 1.0;
        ref.read(audioServiceProvider).setVolume(_volume);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_volume > 0 ? Icons.volume_up : Icons.volume_off, color: AppColors.gold, size: 16),
            const SizedBox(width: 4),
            Text(_volume > 0 ? 'صوت' : 'كتم', style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedButton() {
    return GestureDetector(
      onTap: () => _showSpeedPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.speed, color: AppColors.gold, size: 16),
            const SizedBox(width: 4),
            Text('${_speed}x', style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatButton() {
    String label;
    IconData icon;
    if (_repeatMode == RepeatMode.one) {
      label = 'تكرار 1';
      icon = Icons.repeat_one;
    } else if (_repeatMode == RepeatMode.all) {
      label = 'تكرار الكل';
      icon = Icons.repeat;
    } else {
      label = 'تكرار';
      icon = Icons.repeat;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _repeatMode = switch (_repeatMode) {
            RepeatMode.none => RepeatMode.one,
            RepeatMode.one => RepeatMode.all,
            RepeatMode.all => RepeatMode.none,
          };
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _repeatMode != RepeatMode.none ? AppColors.goldMuted : Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gold, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepTimerButton() {
    final isActive = _sleepTimerMinutes != null;
    return GestureDetector(
      onTap: () => _showSleepTimerPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.goldMuted : Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer, color: AppColors.gold, size: 16),
            const SizedBox(width: 4),
            Text(_sleepTimerLabel(), style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showSleepTimerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('مؤقت النوم', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(color: AppColors.goldMuted, height: 32),
            _timerOption('إيقاف المؤقت', null),
            _timerOption('بعد نهاية السورة الحالية', 0),
            _timerOption('15 دقيقة', 15),
            _timerOption('30 دقيقة', 30),
            _timerOption('45 دقيقة', 45),
            _timerOption('60 دقيقة', 60),
          ],
        ),
      ),
    );
  }

  Widget _timerOption(String label, int? minutes) {
    final selected = _sleepTimerMinutes == minutes;
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: AppColors.gold),
      title: Text(label, style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 16, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        Navigator.pop(context);
        if (minutes == null) {
          _cancelSleepTimer();
        } else {
          _startSleepTimer(minutes);
        }
      },
    );
  }

  void _showSpeedPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('سرعة التشغيل', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(color: AppColors.goldMuted, height: 32),
            ...[0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
              final selected = _speed == speed;
              return ListTile(
                leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: AppColors.gold),
                title: Text('${speed}x', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 16, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                onTap: () {
                  setState(() => _speed = speed);
                  ref.read(audioServiceProvider).setSpeed(speed);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String _reciterName() =>
      QuranAudio.reciters.entries.firstWhere((e) => e.value.code == _reciterCode).key;

  void _showReciterPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('اختر القارئ', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(color: AppColors.goldMuted, height: 32),
            ...QuranAudio.reciters.entries.map((e) {
              final selected = e.value.code == _reciterCode;
              return ListTile(
                leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: AppColors.gold),
                title: Text(e.key, style: TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 18, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                trailing: selected ? const Icon(Icons.check, color: AppColors.gold) : null,
                onTap: () {
                  setState(() => _reciterCode = e.value.code);
                  Navigator.pop(ctx);
                  if (_currentSurah != null) {
                    _playSurah(_currentSurah!);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
