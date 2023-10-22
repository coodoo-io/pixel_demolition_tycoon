import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RiverpodCancelTokenExtension on Ref {
  CancelToken cancelToken() {
    final cancelToken = CancelToken();
    onDispose(cancelToken.cancel);
    return cancelToken;
  }
}
