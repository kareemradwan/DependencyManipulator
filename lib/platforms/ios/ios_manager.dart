import 'dart:io';


import 'build_settings/build_settings_interface.dart';
import 'build_settings/build_settings_manager.dart';

class IosManager implements BuildSettingsInterface {
  final Directory iosDirectory;

  late BuildSettingsInterface buildSettings;

  IosManager(this.iosDirectory) {
    buildSettings = BuildSettingsManager(iosDirectory);
  }

  @override
  Future<String> getAppName() async {
    return buildSettings.getAppName();
  }

  @override
  Future<Map<String, dynamic>> getBundleId() {
    return buildSettings.getBundleId();
  }

  @override
  Future<void> updateAppName(String appName) {
    return buildSettings.updateAppName(appName);
  }

  @override
  Future<void> updateBundleId(String bundleId, String buildConfig) {
    return buildSettings.updateBundleId(bundleId, buildConfig);
  }
}
