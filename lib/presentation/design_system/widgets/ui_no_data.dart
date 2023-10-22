import 'package:flutter/material.dart';

class UiNoData extends StatelessWidget {
  const UiNoData({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Center(child: Text(msg)),
    );
  }
}
