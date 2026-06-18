import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_handler.dart';

class AudioService {
  AudioPlayer get _player {
    if (_handler != null) return _handler!.player;
    return _fallbackPlayer;
  }

  final AudioPlayer _fallbackPlayer = AudioPlayer();
  QuranAudioHandler? _handler;

  PlayerState get state => _player.playerState;
  Stream<PlayerState> get stateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  ProcessingState get processingState => _player.processingState;
  Stream<ProcessingState> get processingStateStream => _player.processingStateStream;

  bool get useHandler => _handler != null;

  AudioService() {
    _handler = QuranAudioHandler.instance;
  }

  Future<void> play(String url, {int? surahNumber, String? surahName, String? reciterName, String? reciterCode}) async {
    if (_handler != null && surahNumber != null) {
      await _handler!.customAction('playSurah', {
        'number': surahNumber,
        'url': url,
        'name': surahName ?? '',
        'reciter': reciterName ?? '',
        'reciterCode': reciterCode ?? 'afs',
      });
    } else {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _player.play();
    }
  }

  Future<void> pause() async => _player.pause();
  Future<void> resume() async => _player.play();
  Future<void> stop() async => _player.stop();
  Future<void> seek(Duration position) async => _player.seek(position);

  Future<void> setVolume(double volume) async {
    if (_handler != null) {
      await _handler!.customAction('setVolume', {'volume': volume});
    }
    await _player.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    if (_handler != null) {
      await _handler!.customAction('setSpeed', {'speed': speed});
    }
    await _player.setSpeed(speed);
  }

  double get speed => _player.speed;

  void dispose() {
    _fallbackPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isPlayingProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(audioServiceProvider);
  return service.stateStream.map((state) => state.playing);
});
