import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_service.g.dart';

enum NetworkStatus {
  notDetermined,
  on,
  off,
}

extension NetworkStatusExtention on NetworkStatus {
  NetworkStatus fromConnectivityResult(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.wifi:
        return NetworkStatus.on;
      case ConnectivityResult.none:
        return NetworkStatus.off;
      default:
        return NetworkStatus.notDetermined;
    }
  }
}

@Riverpod(keepAlive: true)
class IsOffline extends _$IsOffline {
  @override
  bool build() {
    NetworkStatus networkStatus = NetworkStatus.notDetermined;

    // Listen to connectivity
    final subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      networkStatus = networkStatus.fromConnectivityResult(result);
      debugPrint('$networkStatus');
      if (networkStatus == NetworkStatus.on) {
        state = false;
      } else {
        state = true;
      }
    });

    // Cleanup
    ref.onDispose(() {
      subscription.cancel();
    });

    return false;
  }
}
