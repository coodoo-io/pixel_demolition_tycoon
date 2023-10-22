import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/widgets/ui_error.dart';
import 'package:pixel_demolition_tycoon/presentation/design_system/widgets/ui_loading.dart';

// Generic AsyncValueWidget to work with values of type T
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    Key? key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.userErrorMsg,
    this.skipLoadingOnReload = false,
  }) : super(key: key);

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;
  final Widget? error;
  final String? userErrorMsg;
  final bool skipLoadingOnReload;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? const UiLoading(),
      skipLoadingOnReload: skipLoadingOnReload,
      error: (err, stackTrace) {
        final errMsg = 'AsyncValueWidget ${T.toString()}: Error loading data.';
        // FirebaseCrashlytics.instance.recordError(err, stackTrace, reason: errMsg);
        Logger.root.severe(errMsg, err, stackTrace);
        return error ?? const UiError();
      },
    );
  }
}
