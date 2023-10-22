import 'package:flutter/material.dart';

class UiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UiAppBar({
    super.key,
    this.title,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 64,
      title: title,
    );
  }
}
