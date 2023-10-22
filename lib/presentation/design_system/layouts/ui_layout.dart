import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> uiLayoutKey = GlobalKey();

class UiLayout extends StatelessWidget {
  const UiLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: uiLayoutKey,
      body: child,
    );
  }
}
