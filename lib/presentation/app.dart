import 'dart:async';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: game),
            HudWidget(game: game),
            Column(
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SpriteButton.asset(
                      path: 'laserbeam_start_left.png',
                      pressedPath: 'laserbeam_start_left.png',
                      onPressed: () {
                        // add laser beam sound effect
                      },
                      width: 50,
                      height: 80,
                      label: const Text(''),
                    ),
                    Expanded(
                      child: SpriteButton.asset(
                        path: 'laser_beam.png',
                        pressedPath: 'laser_beam.png',
                        onPressed: () {
                          // add laser beam sound effect
                        },
                        width: double.infinity,
                        height: 100,
                        label: const Text(''),
                      ),
                    ),
                    Transform.flip(
                      flipX: true,
                      child: SpriteButton.asset(
                        path: 'laserbeam_start_left.png',
                        pressedPath: 'laserbeam_start_left.png',
                        onPressed: () {
                          // add laser beam sound effect
                        },
                        width: 50,
                        height: 80,
                        label: const Text(''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void upgradeTapStrength() {
    game.upgradeTapStrength();
    setState(() {});
  }
}

class HudWidget extends StatefulWidget {
  const HudWidget({
    super.key,
    required this.game,
  });

  final PixelDemolitionTycoonGame game;

  @override
  State<HudWidget> createState() => _HudWidgetState();
}

class _HudWidgetState extends State<HudWidget> {
  @override
  Widget build(BuildContext context) {
    const hudTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Level: ${widget.game.level}', style: hudTextStyle),
          Text('Strength: ${widget.game.tapStrength}', style: hudTextStyle),
          Text('Money: ${widget.game.money.toStringAsFixed(0)}', style: hudTextStyle),
        ],
      ),
    );
  }
}
