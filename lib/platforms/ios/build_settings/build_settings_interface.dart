abstract class BuildSettingsInterface {
  /// Method to get the current Bundle ID
  Future<Map<String, dynamic>> getBundleId();

  /// Method to update the Bundle ID for the given build config
  Future<void> updateBundleId(String bundleId, String buildConfig);

  /// Method to get the current app name (product name)
  Future<String> getAppName();

  /// Method to update the app name (product name)
  Future<void> updateAppName(String appName);
}
