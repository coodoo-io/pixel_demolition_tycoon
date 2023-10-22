import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/constants/ui_color.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/constants/ui_size.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_plattform.dart';

part 'ui_theme.g.dart';

///
/// Providers
///
@Riverpod(keepAlive: true)
UiTheme uiTheme(UiThemeRef ref) {
  return UiTheme();
}

///
/// The app's UI theme
///
class UiTheme {}
