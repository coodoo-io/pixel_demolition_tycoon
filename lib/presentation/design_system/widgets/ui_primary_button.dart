import 'package:flutter/material.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/widgets/ui_loading.dart';

class UiPrimaryButton extends StatelessWidget {
  const UiPrimaryButton({
    Key? key,
    required this.child,
    this.loadingWidget,
    this.loading = false,
    this.fullWidth = false,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final bool loading;
  final bool fullWidth;
  final Widget? loadingWidget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    const defaultLoadingWidget = UiLoading(padding: EdgeInsets.all(3));

    late final Widget button;
    if (loading) {
      button = ElevatedButton(onPressed: () {}, child: loadingWidget ?? defaultLoadingWidget);
    } else {
      button = ElevatedButton(onPressed: onPressed, child: child);
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
