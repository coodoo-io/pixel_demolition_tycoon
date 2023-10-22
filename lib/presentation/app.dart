import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pixel_demolition_tycoon/common/device/app_lifecycle.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final game = FlameGame();

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
    return GameWidget(game: game);
  }
}
