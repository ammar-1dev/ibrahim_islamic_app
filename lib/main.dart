import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audio_service/audio_service.dart' as audio_svc;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/ai/remote_config_service.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/audio_handler.dart';
import 'core/services/locale_provider.dart';
import 'core/services/error_reporting_service.dart';
import 'core/constants/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorReportingService.instance.recordError(
      details.exception,
      details.stack,
      reason: details.summary.toString(),
    );
  };

  ui.PlatformDispatcher.instance.onError = (error, stack) {
    ErrorReportingService.instance.recordError(error, stack, fatal: true);
    return true;
  };

  ErrorWidget.builder = (details) {
    ErrorReportingService.instance.recordError(
      details.exception,
      details.stack,
      reason: 'Flutter ErrorWidget',
    );
    return const Material(
      color: AppColors.navy,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'عذراً، حدث خطأ غير متوقع',
            style: TextStyle(color: AppColors.error, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await Firebase.initializeApp();
      ErrorReportingService.instance.init();
    } catch (e, stack) {
      ErrorReportingService.instance.recordError(e, stack, reason: 'Firebase.initializeApp failed');
    }
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
    unawaited(audio_svc.AudioService.init(
      builder: () => QuranAudioHandler(),
      config: const audio_svc.AudioServiceConfig(
        androidNotificationChannelId: 'com.ibrahim.islamic.ibrahim.audio',
        androidNotificationChannelName: 'مشغل القرآن',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: true,
        androidNotificationClickStartsActivity: true,
      ),
    ));
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
