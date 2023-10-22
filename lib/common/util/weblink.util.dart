import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pixel_demolition_tycoon/common/translation/translation.extension.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_plattform.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_snackbar.dart';

/// Utility class for opening weblinks
class WeblinkUtil {
  static void openUrl(String url, BuildContext context) async {
    final log = Logger('WeblinkUtil');
    final launchMode = UiPlatform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: launchMode)) {
      log.warning('openUrl: Could not launch $url');
      if (context.mounted) {
        context.errorMsg(message: context.translations.common_weblink_error_msg);
      }
    }
  }
}
