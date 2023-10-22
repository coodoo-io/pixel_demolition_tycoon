import 'dart:io';
import 'package:flutter/foundation.dart';

class UiPlatform {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isReleaseMode => kReleaseMode;
  static bool get isDebugMode => kDebugMode;
  static bool get isTestMode => Platform.environment.containsKey('FLUTTER_TEST');
}
