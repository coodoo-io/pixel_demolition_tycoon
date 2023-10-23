import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pixel_demolition_tycoon/common/device/app_lifecycle.dart';
import 'package:pixel_demolition_tycoon/presentation/screens/pixel_demolition_tycoon_game.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final game = PixelDemolitionTycoonGame();

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
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: [
              GameWidget(game: game),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SpriteButton.asset(
                      path: 'upgrade_button.png',
                      pressedPath: 'upgrade_button.png',
                      onPressed: () {
                        upgradeTapStrength();
                      },
                      width: 100,
                      height: 100,
                      label: const Text(''),
                    ),
                    Text(
                      'Tap Strength: ${game.doubleTapStrength}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void upgradeTapStrength() {
    game.upgradeTapStrength();
    setState(() {});
  }
}
