import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/storage/local_storage.dart';
import 'quran_screen.dart';
import 'widgets/ayah_audio_player.dart';

class AyahModel {
  final int numberInSurah;
  final String text;
  final String? translation;

  const AyahModel({required this.numberInSurah, required this.text, this.translation});
}

final surahContentProvider = FutureProvider.family<List<AyahModel>, int>((ref, surahNumber) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get(
    'https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,en.asad',
  );
  final editions = res.data['data'] as List;
  final arabic = (editions[0]['ayahs'] as List);
  final english = (editions[1]['ayahs'] as List);

  return List.generate(arabic.length, (i) {
    return AyahModel(
      numberInSurah: (arabic[i]['numberInSurah'] as int),
      text: arabic[i]['text'] as String,
      translation: english[i]['text'] as String?,
    );
  });
});

class SurahReaderScreen extends ConsumerWidget {
  final SurahMeta surah;
  const SurahReaderScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(surahContentProvider(surah.number));
    final storage = LocalStorage();

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: Text(surah.nameArabic),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: ayahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('تعذّر تحميل السورة', style: TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 20)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(surahContentProvider(surah.number)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
                child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.navy)),
              ),
            ],
          ),
        ),
        data: (ayahs) => ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.lg),
          itemCount: ayahs.length,
          itemBuilder: (context, index) => _AyahCard(
            ayah: ayahs[index],
            surahNumber: surah.number,
            storage: storage,
          ),
        ),
      ),
    );
  }
}

class _AyahCard extends StatefulWidget {
  final AyahModel ayah;
  final int surahNumber;
  final LocalStorage storage;
  const _AyahCard({required this.ayah, required this.surahNumber, required this.storage});

  @override
  State<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<_AyahCard> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.storage.isBookmarked('${widget.surahNumber}:${widget.ayah.numberInSurah}');
  }

  void _toggleBookmark() {
    final key = '${widget.surahNumber}:${widget.ayah.numberInSurah}';
    if (_isBookmarked) {
      widget.storage.removeBookmark(key);
    } else {
      widget.storage.addBookmark(key);
    }
    setState(() => _isBookmarked = !_isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.lg),
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.goldMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.goldMuted, shape: BoxShape.circle),
                child: Center(
                  child: Text('${widget.ayah.numberInSurah}',
                    style: const TextStyle(color: AppColors.gold, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _toggleBookmark,
                    icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: AppColors.gold, size: 20),
                  ),
                  AyahAudioPlayer(
                    surahNumber: widget.surahNumber,
                    ayahNumber: widget.ayah.numberInSurah,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            widget.ayah.text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.textOnDark, fontFamily: 'Amiri', fontSize: 24, height: 2.2),
          ),
          if (widget.ayah.translation != null) ...[
            const SizedBox(height: AppDimensions.md),
            const Divider(color: AppColors.goldMuted),
            const SizedBox(height: AppDimensions.sm),
            Text(
              widget.ayah.translation!,
              style: const TextStyle(color: AppColors.textOnDarkMuted, fontFamily: 'Inter', fontSize: 13, fontStyle: FontStyle.italic, height: 1.6),
            ),
          ],
        ],
      ),
    );
  }
}
