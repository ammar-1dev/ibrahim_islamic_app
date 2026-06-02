import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  }

  runApp(
    const ProviderScope(
      child: IbrahimApp(),
    ),
  );
}
