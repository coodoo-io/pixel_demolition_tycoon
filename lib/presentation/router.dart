import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pixel_demolition_tycoon/common/go_router/fade_transition_page.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/layouts/ui_layout.dart';
import 'package:pixel_demolition_tycoon/presentation/screens/dashboard/dashboard.screen.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell layout');

enum UiRoute { dashboard }

@Riverpod(keepAlive: true)
Raw<GoRouter> router(RouterRef ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode ? true : false,
    initialLocation: '/',
    // observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        // observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
        builder: (context, state, child) {
          return UiLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: UiRoute.dashboard.name,
            pageBuilder: (context, state) {
              return FadeTransitionPage(
                key: state.pageKey,
                child: const DashboardScreen(),
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      Logger.root.info('Redirecting: ${state.uri.toString()}');

      return null;
    },
  );

  ref.onDispose(router.dispose);
  return router;
}
