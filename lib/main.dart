import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audio_service/audio_service.dart' as audio_svc;
import 'app.dart';
import 'core/ai/remote_config_service.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/audio_handler.dart';
import 'core/services/locale_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
    await RemoteConfigService.init();
  }

  if (!Platform.isAndroid && !Platform.isIOS) {
    final dir = Directory('${Platform.environment['HOME'] ?? '.'}/.ibrahim_app');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    await LocalStorage.init(path: dir.path);
  } else {
    await LocalStorage.init();
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  ApiClient().init();

  if (Platform.isAndroid || Platform.isIOS) {
    await NotificationService().init();
    NotificationService().scheduleAll();
    await audio_svc.AudioService.init(
      builder: () => QuranAudioHandler(),
      config: const audio_svc.AudioServiceConfig(
        androidNotificationChannelId: 'com.ibrahim.islamic.ibrahim.audio',
        androidNotificationChannelName: 'مشغل القرآن',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: true,
        androidNotificationClickStartsActivity: true,
      ),
    );
  }

  final container = ProviderContainer();
  await container.read(localeProvider.notifier).load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const IbrahimApp(),
    ),
  );
}
