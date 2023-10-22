import 'package:flutter/material.dart';

class UiLoading extends StatelessWidget {
  const UiLoading({
    super.key,
    this.color,
    this.padding = const EdgeInsets.all(20),
    this.size = 24,
    this.strokeWidth = 3,
  });

  final EdgeInsets padding;
  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color,
          ),
        ),
      ),
    );
  }
}
