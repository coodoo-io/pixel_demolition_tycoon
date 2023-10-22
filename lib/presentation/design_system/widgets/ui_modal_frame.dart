import 'package:flutter/material.dart';

class UiModelFrame extends StatelessWidget {
  const UiModelFrame({
    super.key,
    required this.child,
    this.height,
    this.heightFactor = 0.75,
    this.maxHeight = double.infinity,
    this.maxWidth = 500,
    this.constraints,
  });

  final Widget child;
  final double? height; // Fixed height
  final double heightFactor; // Percentage of screen like FractionalSizedBox
  final double maxWidth;
  final double maxHeight;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final defaultConstraints = BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight);
    const borderRadius = BorderRadius.all(Radius.circular(24));

    return Container(
      margin: const EdgeInsets.all(12),
      height: height ?? (MediaQuery.of(context).size.height / 100) * heightFactor * 100,
      constraints: constraints ?? defaultConstraints,
      decoration: const BoxDecoration(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -24,
                  right: -24,
                  child: IconButton(
                    constraints: const BoxConstraints(
                      minHeight: 60,
                      minWidth: 60,
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 40,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned.fill(top: 20, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
