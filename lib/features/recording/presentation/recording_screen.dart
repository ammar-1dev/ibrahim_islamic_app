import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/recording_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final _service = RecordingService();
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  List<File> _recordings = [];

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final files = await _service.getSavedRecordings();
    if (mounted) setState(() => _recordings = files);
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _service.stopRecording();
      _timer?.cancel();
      setState(() => _isRecording = false);
      await _loadRecordings();
    } else {
      await _service.requestPermission();
      await _service.startRecording();
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _recordingDuration += const Duration(seconds: 1));
      });
    }
  }

  Future<void> _togglePlayback(String path) async {
    if (_isPlaying) {
      await _service.stopPlayback();
      setState(() => _isPlaying = false);
    } else {
      await _service.playRecording(path);
      setState(() => _isPlaying = true);
      _service.stopPlayback().then((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
    }
  }

  Future<void> _deleteRecording(String path) async {
    await _service.deleteRecording(path);
    await _loadRecordings();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('التسجيل الصوتي'),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.xl),
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? Colors.red : AppColors.gold,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : AppColors.gold).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: AppColors.navy,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            _isRecording ? _fmt(_recordingDuration) : 'اضغط للتسجيل',
            style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 20),
          ),
          if (_isRecording)
            const Padding(
              padding: EdgeInsets.only(top: AppDimensions.sm),
              child: Text('جاري التسجيل...', style: TextStyle(color: Colors.redAccent, fontFamily: 'Amiri', fontSize: 14)),
            ),
          const SizedBox(height: AppDimensions.xl),
          const Divider(color: AppColors.goldMuted, thickness: 0.5),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.md),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('التسجيلات السابقة', style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 18)),
            ),
          ),
          Expanded(
            child: _recordings.isEmpty
              ? const Center(
                  child: Text('لا توجد تسجيلات', style: TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Amiri', fontSize: 16)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  itemCount: _recordings.length,
                  itemBuilder: (ctx, i) {
                    final file = _recordings[i];
                    final modified = file.lastModifiedSync();
                    final size = file.lengthSync();
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: AppColors.navyLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        border: Border.all(color: AppColors.goldMuted.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, color: AppColors.gold),
                          onPressed: () => _togglePlayback(file.path),
                        ),
                        title: Text(
                          '${modified.hour.toString().padLeft(2, '0')}:${modified.minute.toString().padLeft(2, '0')} ${modified.year}-${modified.month.toString().padLeft(2, '0')}-${modified.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Inter', fontSize: 14),
                        ),
                        subtitle: Text(
                          '${(size / 1024).toStringAsFixed(1)} KB',
                          style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => _deleteRecording(file.path),
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
}
