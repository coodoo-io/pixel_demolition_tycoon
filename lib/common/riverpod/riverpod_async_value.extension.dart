import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RiverpodAsyncValueExtension on AsyncValue {
  // isLoading shorthand (AsyncLoading is a subclass of AsycValue)
  bool get isLoading => this is AsyncLoading;
}
