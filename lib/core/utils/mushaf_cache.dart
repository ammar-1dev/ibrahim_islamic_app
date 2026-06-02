import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../di/providers.dart';

class MushafCacheService {
  final Dio dio;
  Directory? _cacheDir;

  static const String _baseUrl = 'https://raw.githubusercontent.com/QuranHub/quran-pages-images/main/easyquran.com/hafs-tajweed';
  static const int totalPages = 604;

  MushafCacheService(this.dio);

  Future<Directory> _getCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/mushaf_pages');
    if (!_cacheDir!.existsSync()) {
      _cacheDir!.createSync(recursive: true);
    }
    return _cacheDir!;
  }

  Future<String> getPagePath(int pageNum) async {
    final dir = await _getCacheDir();
    return '${dir.path}/page_$pageNum.jpg';
  }

  Future<bool> isPageCached(int pageNum) async {
    final path = await getPagePath(pageNum);
    return File(path).existsSync();
  }

  Future<int> cachedCount() async {
    final dir = await _getCacheDir();
    final files = dir.listSync().where((f) => f.path.endsWith('.jpg'));
    return files.length;
  }

  Future<void> downloadPage(int pageNum) async {
    final path = await getPagePath(pageNum);
    final file = File(path);
    if (file.existsSync()) return;
    await dio.download('$_baseUrl/$pageNum.jpg', path);
  }

  Future<void> downloadAll(void Function(int downloaded, int total) onProgress) async {
    final dir = await _getCacheDir();
    final existing = dir.listSync().where((f) => f.path.endsWith('.jpg')).length;
    if (existing >= totalPages) return;

    for (int i = 1; i <= totalPages; i++) {
      final path = '${dir.path}/page_$i.jpg';
      final file = File(path);
      if (!file.existsSync()) {
        await dio.download('$_baseUrl/$i.jpg', path);
      }
      onProgress(i, totalPages);
    }
  }

  Future<int> deleteAll() async {
    final dir = await _getCacheDir();
    int count = 0;
    for (final f in dir.listSync()) {
      await f.delete();
      count++;
    }
    return count;
  }
}

final mushafCacheServiceProvider = Provider<MushafCacheService>((ref) {
  return MushafCacheService(ref.read(dioProvider));
});

final mushafDownloadProgressProvider = StateNotifierProvider<MushafDownloadProgressNotifier, AsyncValue<int?>>((ref) {
  return MushafDownloadProgressNotifier(ref.read(mushafCacheServiceProvider));
});

class MushafDownloadProgressNotifier extends StateNotifier<AsyncValue<int?>> {
  final MushafCacheService service;

  MushafDownloadProgressNotifier(this.service) : super(const AsyncData(null));

  Future<void> startDownload() async {
    state = const AsyncLoading();
    try {
      await service.downloadAll((downloaded, total) {
        state = AsyncData(downloaded);
      });
      state = AsyncData(604);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> checkStatus() async {
    final count = await service.cachedCount();
    state = AsyncData(count == 604 ? 604 : count);
  }
}
