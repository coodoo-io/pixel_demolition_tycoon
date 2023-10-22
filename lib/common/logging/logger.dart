import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/utils/ui_plattform.dart';

Future<void> setupLogger({required Level level}) async {
  Logger.root.level = level;
  // return defaultCreatePrintAppender(stderrLevel: level)..attachToLogger(Logger.root);
  // Logger.root.onRecord.listen((record) {
  //   print('${record.level.name}: ${record.time}: ${record.message}');
  // });

  // Logger.root.onRecord.listen((record) {
  //   log('${record.time} ${record.level.name} [${record.loggerName}] ${record.message}');
  // });

  if (UiPlatform.isDebugMode) {
    PrintAppender(formatter: const ColorFormatter()).attachToLogger(Logger.root);
  } else {
    PrintAppender().attachToLogger(Logger.root);
  }
}
