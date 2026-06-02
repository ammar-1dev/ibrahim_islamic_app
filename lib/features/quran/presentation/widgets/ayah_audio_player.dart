import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/audio_service.dart';
import '../../../../../core/utils/quran_audio.dart';

class AyahAudioPlayer extends ConsumerStatefulWidget {
  final int surahNumber;
  final int ayahNumber;
  const AyahAudioPlayer({super.key, required this.surahNumber, required this.ayahNumber});

  @override
  ConsumerState<AyahAudioPlayer> createState() => _AyahAudioPlayerState();
}

class _AyahAudioPlayerState extends ConsumerState<AyahAudioPlayer> {
  bool _isPlaying = false;
  bool _isLoading = false;

  Future<void> _toggle() async {
    if (_isPlaying) {
      await ref.read(audioServiceProvider).pause();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(audioServiceProvider).play(
        QuranAudio.getAyahUrl(widget.surahNumber, widget.ayahNumber),
      );
      setState(() => _isPlaying = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تشغيل التسجيل')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: _isPlaying ? AppColors.gold : AppColors.goldMuted,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy))
              : Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: _isPlaying ? AppColors.navy : AppColors.gold,
                  size: 20,
                ),
        ),
      ),
    );
  }
}
