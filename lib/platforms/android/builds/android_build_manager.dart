import 'dart:io';

import '../../../../util/console.dart';
import '../../../../util/file.dart';
import 'android_build_interface.dart';

class AndroidBuildManager implements AndroidBuildInterface {
  @override
  Future<bool> build() async {
    var result =
        await Process.run('bash', ['-c', 'cd android && ./gradlew build']);

    if (result.exitCode != 0) {
      printError("android build: error    =>\n${result.stderr}");
    }
    return result.exitCode == 0;
  }

  @override
  Future<void> prepareEnv(
      {String? minSdkVersion,
      String? targetSdkVersion,
      String? compileSdkVersion}) async {
    var buildFile = File("${Directory.current.path}/android/app/build.gradle");

    if (!buildFile.existsSync()) {
      throw Exception(
          "Error on Configure android, missing file: /android/app/build.gradle");
    }

    var lines = await buildFile.linesIndexed();
    MapEntry minSdkVersionMap = const MapEntry(-1, "");
    MapEntry targetSdkVersionMap = const MapEntry(-1, "");
    MapEntry compileSdkVersionMap = const MapEntry(-1, "");

    lines.forEach((key, value) {
      if (value.contains("minSdkVersion")) {
        minSdkVersionMap = MapEntry(key, value);
      }

      if (value.contains("targetSdkVersion")) {
        targetSdkVersionMap = MapEntry(key, value);
      }
      if (value.contains("compileSdkVersion")) {
        compileSdkVersionMap = MapEntry(key, value);
      }
    });

    if (minSdkVersionMap.key == -1 ||
        targetSdkVersionMap.key == -1 ||
        compileSdkVersionMap.key == -1) {
      throw Exception(
          "Error on Configure android, invalid content of  /android/app/build.gradle missing one of the following: [minSdkVersionMap, targetSdkVersionMap, compileSdkVersion]");
    }

    lines[minSdkVersionMap.key] =
        "        minSdkVersion ${minSdkVersion ?? 22}";
    lines[targetSdkVersionMap.key] =
        "        targetSdkVersion ${targetSdkVersion ?? 30}";
    lines[compileSdkVersionMap.key] =
        "    compileSdkVersion ${compileSdkVersion ?? 33}";

    buildFile.writeAsStringSync(lines.values.join("\n"));
  }
}
