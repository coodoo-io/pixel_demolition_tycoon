import 'package:flutter/material.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/constants/ui_size.dart';

/// A simple page frame, to keep the design of a page consistent (padding, scrolling (default true),...)
class UiPageLayout extends StatelessWidget {
  const UiPageLayout({
    super.key,
    required this.child,
    this.noPadding = false,
    this.scrollable = true,
  });

  final Widget child;
  final bool noPadding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = noPadding ? 0.0 : UiSize.s16;
    return scrollable
        ? SingleChildScrollView(
            // always scrollable is required to use pull-to-refresh
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: UiSize.s16, horizontal: horizontalPadding),
            child: child,
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: UiSize.s16, horizontal: horizontalPadding),
            child: child,
          );
  }
}
