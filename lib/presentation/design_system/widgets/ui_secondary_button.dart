import 'package:flutter/material.dart';

class UiSecondaryButton extends StatelessWidget {
  const UiSecondaryButton({
    Key? key,
    required this.child,
    this.fullWidth = false,
    this.onPressed,
    this.active = true,
  }) : super(key: key);

  final Widget child;
  final bool fullWidth;
  final void Function()? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Widget button = active
        ? TextButton(onPressed: onPressed, child: child)
        : TextButton(
            onPressed: () {},
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
            child: child,
          );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
