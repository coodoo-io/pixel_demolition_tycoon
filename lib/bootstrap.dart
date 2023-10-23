import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:pixel_demolition_tycoon/common/logging/logger.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_package_info.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_plattform.dart';

// Helper Function to handle errors easily
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Handle uncaught framework errors
  FlutterError.onError = (details) {
    if (UiPlatform.isDebugMode) {
      FlutterError.presentError(details);
    }
    Logger.root.severe('bootstrap: ${details.exceptionAsString()}', details.exceptionAsString(), details.stack);
    // FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  // Handle errors from the underlying Platform/OS
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    Logger.root.severe('bootstrap: $error', error, stackTrace);
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    return true;
  };

  // Run app in zone to catch application errors
  await runZonedGuarded(
    () async {
      // Test with slow animations
      // timeDilation = 3.0;

      // Setup Logger
      setupLogger(level: UiPlatform.isDebugMode ? Level.INFO : Level.WARNING);
      Logger.root.info('main: Pixel Demolition Tycoon app started');

      // Localization: Get device locale
      Intl.systemLocale = await findSystemLocale();

      // Makes sure plugins are initialized
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      // Keep native Splashscreen open
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      /// Firebase
      // await Firebase.initializeApp(
      //   name: 'PixelDemolitionTycoon',
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      /// Firebase - Analytics
      // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

      if (UiPlatform.isDebugMode) {
        // Force disable Crashlytics and Analytics collection while doing every day development.
        // Temporarily toggle this to true if you want to test reporting in your app.
        // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
        // await analytics.setAnalyticsCollectionEnabled(false);
      } else {
        // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        // await analytics.setAnalyticsCollectionEnabled(true);
      }

      // System chrome
      if (UiPlatform.isAndroid) {
        // Edge to Edge is not default in android so it must be enabled
        // https://github.com/flutter/flutter/issues/86248
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
      }

      Flame.device.fullScreen();
      Flame.device.setPortrait();

      // Initialize Riverpod
      final container = ProviderContainer();
      await container.read(uiPackageInfoProvider.future);

      // Close native Splashscreen after in constants defined duration
      // await Future.delayed(const Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
      FlutterNativeSplash.remove();

      return runApp(
        UncontrolledProviderScope(
          container: container,
          // observers: [RiverpodLogger()],
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) {
      if (UiPlatform.isWeb || UiPlatform.isDebugMode) {
        Logger.root.severe('bootstrap: zone-error', error, stackTrace);
      } else {
        // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      }
    },
  );
}
