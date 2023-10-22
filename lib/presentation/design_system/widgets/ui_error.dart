import 'package:flutter/material.dart';
import 'package:pixel_demolition_tycoon/common/translation/translation.extension.dart';

/// Widget to present the user an Error
/// TODO: Make this handle errorCodes and translation
class UiError extends StatelessWidget {
  const UiError({super.key, this.msg});

  /// The message presented to the user
  final String? msg;

  @override
  Widget build(BuildContext context) {
    String defaultErrorMsg = context.translations.common_default_error_message;
    final errorMsg = msg ?? defaultErrorMsg;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red, height: 1.5),
      ),
    );
  }
}
