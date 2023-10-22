import 'package:flutter/material.dart';

/// Extension
extension SnackBarExtension on BuildContext {
  void showSnackBar({required String message, SnackBarAction? action, Duration? duration}) {
    UiSnackbar.msg(state: ScaffoldMessenger.of(this), message: message, action: action, duration: duration);
  }

  void errorMsg({required String message, SnackBarAction? action}) {
    UiSnackbar.errorMsg(state: ScaffoldMessenger.of(this), message: message, action: action);
  }
}

/// Class for Snackbar
class UiSnackbar {
  static void msg({
    required ScaffoldMessengerState state,
    required String message,
    SnackBarAction? action,
    bool showCloseIcon = true,
    Duration? duration,
    Color backgroundColor = const Color(0xff04041e),
  }) {
    _clearSnackBar(state);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      showCloseIcon: showCloseIcon,
      duration: duration ?? const Duration(seconds: 5),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 12),
      content:
          Text(message, style: const TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 18)),
      elevation: 2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      backgroundColor: backgroundColor,
      action: action,
    );
    state.showSnackBar(snackBar);
  }

  static void errorMsg({required ScaffoldMessengerState state, required String message, SnackBarAction? action}) {
    _clearSnackBar(state);
    msg(
      state: state,
      message: message,
      backgroundColor: Colors.redAccent,
      action: action,
      duration: const Duration(seconds: 15),
    );
  }

  static void _clearSnackBar(ScaffoldMessengerState state) {
    state.hideCurrentSnackBar();
  }
}
