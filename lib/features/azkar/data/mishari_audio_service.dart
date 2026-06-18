import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class MishariAzkarAudioService {
  final AudioPlayer _player = AudioPlayer();

  String? _currentCategory;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isLoading = false;
  int _totalItems = 0;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  bool get isLoading => _isLoading;
  int get currentIndex => 0;
  int get totalItems => _totalItems;
  String? get currentCategory => _currentCategory;

  void Function(String category)? onStarted;
  void Function()? onCompleted;
  void Function()? onStopped;

  MishariAzkarAudioService() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _isPaused = false;
        _currentCategory = null;
        onCompleted?.call();
      }
    });
  }

  Future<void> playMorning({int totalAthkar = 60}) async {
    await _playAsset('assets/audio/azkar_morning.mp3', 'morning', totalAthkar);
  }

  Future<void> playEvening({int totalAthkar = 40}) async {
    await _playAsset('assets/audio/azkar_evening.mp3', 'evening', totalAthkar);
  }

  Future<void> _playAsset(String path, String category, int total) async {
    await _player.stop();
    _currentCategory = category;
    _totalItems = total;
    _isPaused = false;
    try {
      await _player.setAudioSource(AudioSource.asset(path));
      await _player.play();
      _isPlaying = true;
      onStarted?.call(category);
    } catch (e) {
      _isPlaying = false;
      _currentCategory = null;
    }
  }

  Future<void> togglePause() async {
    if (_isPlaying) {
      await _player.pause();
      _isPaused = true;
    } else if (_isPaused) {
      await _player.play();
      _isPaused = false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
    _isPlaying = false;
    _isPaused = false;
    _currentCategory = null;
    onStopped?.call();
  }

  void dispose() {
    _player.dispose();
  }
}

final mishariAzkarAudioProvider = Provider<MishariAzkarAudioService>((ref) {
  final service = MishariAzkarAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
