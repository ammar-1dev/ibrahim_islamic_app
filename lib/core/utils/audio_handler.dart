import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioHandler extends BaseAudioHandler {
  static QuranAudioHandler? instance;

  final AudioPlayer player = AudioPlayer();

  int? currentSurah;
  String _surahName = '';
  String _reciterName = '';
  String _reciterCode = 'afs';
  double _speed = 1.0;
  double _volume = 1.0;

  QuranAudioHandler() {
    instance = this;
    player.playerStateStream.listen(_onPlayerStateChanged);
    player.processingStateStream.listen((_) {});
    player.positionStream.listen((pos) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: pos,
      ));
    });
    player.durationStream.listen((dur) {
      if (dur != null) {
        playbackState.add(playbackState.value.copyWith(
          bufferedPosition: dur,
        ));
      }
    });
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> stop() async {
    await player.stop();
    currentSurah = null;
  }

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToNext() async {
    final next = (currentSurah ?? 0) + 1;
    if (next <= 114) {
      await _playByNumber(next);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final prev = (currentSurah ?? 2) - 1;
    if (prev >= 1) {
      await _playByNumber(prev);
    }
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? args]) async {
    switch (name) {
      case 'playSurah':
        final number = args?['number'] as int;
        final url = args?['url'] as String;
        final nameStr = args?['name'] as String?;
        final reciter = args?['reciter'] as String?;
        _reciterCode = args?['reciterCode'] as String? ?? 'afs';
        await _playSurah(number, url, nameStr: nameStr, reciter: reciter);
        break;
      case 'setSpeed':
        _speed = (args?['speed'] as num?)?.toDouble() ?? 1.0;
        await player.setSpeed(_speed);
        break;
      case 'setVolume':
        _volume = (args?['volume'] as num?)?.toDouble() ?? 1.0;
        await player.setVolume(_volume);
        break;
      case 'getState':
        return {
          'currentSurah': currentSurah,
          'isPlaying': player.playing,
          'position': player.position.inMilliseconds,
          'duration': player.duration?.inMilliseconds,
          'speed': _speed,
          'volume': _volume,
          'reciterCode': _reciterCode,
          'surahName': _surahName,
        };
    }
    return null;
  }

  Future<void> _playSurah(int number, String url, {String? nameStr, String? reciter}) async {
    currentSurah = number;
    _surahName = nameStr ?? '';
    _reciterName = reciter ?? '';

    mediaItem.add(MediaItem(
      id: url,
      title: _surahName,
      artist: _reciterName,
    ));

    await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    if (player.speed != _speed) {
      await player.setSpeed(_speed);
    }
    if (player.volume != _volume) {
      await player.setVolume(_volume);
    }
    await player.play();
  }

  Future<void> _playByNumber(int number) async {
    final url = _buildSurahUrl(number, _reciterCode);
    await _playSurah(number, url, nameStr: _surahName, reciter: _reciterName);
  }

  String _buildSurahUrl(int number, String code) {
    final num = number.toString().padLeft(3, '0');
    return 'https://server8.mp3quran.net/$code/$num.mp3';
  }

  void _onPlayerStateChanged(PlayerState state) {
    playbackState.add(playbackState.value.copyWith(
      playing: state.playing,
      processingState: switch (state.processingState) {
        ProcessingState.idle => AudioProcessingState.idle,
        ProcessingState.loading => AudioProcessingState.loading,
        ProcessingState.buffering => AudioProcessingState.buffering,
        ProcessingState.ready => AudioProcessingState.ready,
        ProcessingState.completed => AudioProcessingState.completed,
      },
    ));
  }

  void dispose() {
    player.dispose();
  }
}
