import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/font_size_provider.dart';
import 'core/constants/app_strings.dart';
import 'core/services/locale_provider.dart';

class IbrahimApp extends ConsumerWidget {
  const IbrahimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final fontScale = ref.watch(fontScaleNotifierProvider);
    final locale = ref.watch(localeProvider);
    final rtl = isRTL(locale);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(fontScale)),
          child: Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
        );
      },
    );
  }
}
