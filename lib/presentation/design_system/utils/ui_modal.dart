import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_demolition_tycoon/common/translation/translation.extension.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/widgets/ui_secondary_button.dart';

class UiModal {
  static Future<T?> openModal<T extends Object?>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    double? dialogHeight,
  }) {
    return showGeneralDialog<T>(
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: SizedBox(height: dialogHeight, child: child),
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6 * anim1.value, sigmaY: 6 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: SafeArea(child: child),
        ),
      ),
      context: context,
    );
  }

  static Future<T?> openAlertDialog<T>({
    required BuildContext context,
    required Widget title,
    required Widget content,
  }) {
    final dialog = AlertDialog(
      title: title,
      content: content,
      elevation: 2,
      actions: [
        UiSecondaryButton(
          child: Text(context.translations.common_ok),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    );
    return openModal(context: context, child: dialog);
  }

  static Future<T?> openConfirmDialog<T>({
    required BuildContext context,
    required Widget title,
    required Widget content,
    required String yesLabel,
    required String noLabel,
    VoidCallback? yesCallback,
    VoidCallback? noCallback,
  }) {
    final theme = Theme.of(context);

    final dialog = AlertDialog(
      title: title,
      content: content,
      elevation: 2,
      actions: [
        UiSecondaryButton(
          onPressed: noCallback,
          child: Text(
            noLabel,
            style: theme.textTheme.bodySmall,
          ),
        ),
        UiSecondaryButton(
          onPressed: yesCallback,
          child: Text(
            yesLabel,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
    return openModal(context: context, child: dialog);
  }

  static Future<T?> openBottomSheet<T>({required BuildContext context, required Widget child}) {
    final theme = Theme.of(context);
    final double safePadding = MediaQuery.of(context).padding.bottom;

    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: theme.dialogBackgroundColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [child, SizedBox(height: safePadding)],
        );
      },
    );
  }
}
