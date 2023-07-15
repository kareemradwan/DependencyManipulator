abstract class AndroidBuildInterface {
  Future<bool> build();

  Future<void> prepareEnv(
      {String? applicationId,
      String? minSdkVersion,
      String? targetSdkVersion,
      String? compileSdkVersion});
}
