import 'package:flutter/material.dart';

class UiInputLabel extends StatelessWidget {
  const UiInputLabel({super.key, required this.label, this.leftPadding = 24.0});
  final String label;
  final double leftPadding;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 3),
      child: Text(label, style: theme.textTheme.labelMedium),
    );
  }
}
