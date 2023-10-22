import 'package:flutter/material.dart';

extension FormExtension on GlobalKey<FormState> {
  bool validate() {
    return currentState != null && currentState!.validate();
  }
}
