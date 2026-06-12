import 'dart:io';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class RecordingService {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  String? _currentFilePath;

  Future<bool> isRecording() => _recorder.isRecording();

  Future<bool> requestPermission() async {
    final hasAudio = await _recorder.hasPermission();
    if (!hasAudio) {
      return _recorder.hasPermission();
    }
    return true;
  }

  Future<String?> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${dir.path}/recording_$timestamp.m4a';
    _currentFilePath = path;
    await _recorder.start(const RecordConfig(), path: path);
    return path;
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path ?? _currentFilePath;
  }

  Future<void> playRecording(String path) async {
    if (await File(path).exists()) {
      await _player.setFilePath(path);
      await _player.play();
    }
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<List<File>> getSavedRecordings() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.m4a')).toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files;
  }

  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}
