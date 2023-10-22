import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Keeps a provider alive for [duration]
extension RiverpodCacheTimeExtension on AutoDisposeRef {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}
