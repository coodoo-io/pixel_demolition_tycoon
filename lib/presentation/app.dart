import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pixel_demolition_tycoon/common/device/app_lifecycle.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/ui_theme.dart';
import 'package:pixel_demolition_tycoon/presentation/router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(
      AppLifecycleObserver(
        resumeCallBack: () async {
          Logger.root.info('AppLifecycleObserver: App has resumed');
        },
        suspendingCallBack: () async {
          Logger.root.info('AppLifecycleObserver: App has paused');
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final uiTheme = ref.watch(uiThemeProvider);
    // final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    // final language = ref.watch(settingsProvider.select((s) => s.language));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'pixel_demolition_tycoon',
      theme: uiTheme.lightTheme,
      darkTheme: uiTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // set default locale
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale?.languageCode) {
            return locale;
          }
        }
        return const Locale('en');
      },
    );
  }
}
