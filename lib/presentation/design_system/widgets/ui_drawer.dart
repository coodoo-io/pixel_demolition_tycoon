import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiDrawer extends ConsumerWidget {
  const UiDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Drawer(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}
