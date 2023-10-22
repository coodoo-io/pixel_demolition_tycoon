import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_package_info.g.dart';

/// Provider
@Riverpod(keepAlive: true)
Future<UiPackageInfo> uiPackageInfo(UiPackageInfoRef ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return UiPackageInfo(packageInfo: packageInfo);
}

/// Class to get build number and version
class UiPackageInfo {
  UiPackageInfo({required this.packageInfo});
  final PackageInfo packageInfo;

  String? getBuildNumberAndVersion() {
    if (packageInfo.version.isEmpty) {
      return null;
    }
    return 'Version ${getVersion()} (Build ${getBuildNumber()})';
  }

  String? getBuildNumber() {
    if (packageInfo.appName.isEmpty) {
      return null;
    }
    return packageInfo.buildNumber;
  }

  String? getVersion() {
    if (packageInfo.appName.isEmpty) {
      return null;
    }
    return packageInfo.version;
  }
}
