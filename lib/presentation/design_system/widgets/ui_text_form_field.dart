import 'package:flutter/material.dart';

/// A [TextFormField] with some default configurations.
class UiTextFormField extends StatelessWidget {
  const UiTextFormField({
    super.key,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.decoration,
    this.obscureText = false,
    this.onEditingComplete,
    this.validator,
  });

  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final InputDecoration? decoration;
  final bool obscureText;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHints,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      textCapitalization: textCapitalization,
      decoration: decoration,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      validator: validator,
    );
  }
}
