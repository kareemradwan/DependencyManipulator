abstract class AndroidBuildInterface {
  Future<bool> build();

  Future<void> prepareEnv(
      {String? minSdkVersion,
      String? targetSdkVersion,
      String? compileSdkVersion});
}
