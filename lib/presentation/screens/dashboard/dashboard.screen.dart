import 'package:flutter/material.dart';
import 'package:pixel_demolition_tycoon/common/translation/translation.extension.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/layouts/ui_page_layout.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/widgets/ui_app_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiAppBar(
        title: Text(context.translations.screen_dashboard_title),
      ),
      body: UiPageLayout(
        child: Text(context.translations.screen_dashboard_title),
      ),
    );
  }
}
