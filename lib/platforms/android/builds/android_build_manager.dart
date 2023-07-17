import 'dart:io';

import '../../../../util/console.dart';
import '../../../../util/file.dart';
import 'android_build_interface.dart';

class AndroidBuildManager implements AndroidBuildInterface {
  final Directory androidDirectory;

  AndroidBuildManager(this.androidDirectory);

  @override
  Future<bool> build() async {
    var result = await Process.run(
        'bash', ['-c', 'cd ${androidDirectory.path} && ./gradlew build']);

    if (result.exitCode != 0) {
      printError("android build: error    =>\n${result.stderr}");
    }
    return result.exitCode == 0;
  }

  @override
  Future<void> prepareEnv({
    String? appName,
    String? applicationId,
    String? minSdkVersion,
    String? targetSdkVersion,
    String? compileSdkVersion,
  }) async {
    final buildFile = File("${androidDirectory.path}/app/build.gradle");
    if (!buildFile.existsSync()) {
      throw Exception(
          "Error on Configure android, missing file: /android/app/build.gradle");
    }

    var content = await buildFile.readAsString();

    // Replace appName
    if (appName != null) {
      final matches =
          RegExp(r'resValue "string", "app_name", "[^"]+"').allMatches(content);
      if (matches.isEmpty) {
        throw Exception(
            'Error: resValue "string", "app_name", not found in build.gradle file');
      }
      for (var match in matches) {
        content = content.replaceRange(
          match.start,
          match.end,
          'resValue "string", "app_name","$appName"',
        );
      }
    }
    // Replace applicationId
    if (applicationId != null) {
      var match = RegExp(r'applicationId "[^"]+"').firstMatch(content);
      if (match == null) {
        throw Exception('Error: applicationId not found in build.gradle file');
      }
      content = content.replaceRange(
        match.start,
        match.end,
        'applicationId "$applicationId"',
      );
    }

    // Replace minSdkVersion
    if (minSdkVersion != null) {
      content = content.replaceAll(
        RegExp(r'minSdkVersion \d+'),
        'minSdkVersion $minSdkVersion',
      );
    }

    // Replace targetSdkVersion
    if (targetSdkVersion != null) {
      content = content.replaceAll(
        RegExp(r'targetSdkVersion \d+'),
        'targetSdkVersion $targetSdkVersion',
      );
    }

    // Replace compileSdkVersion
    if (compileSdkVersion != null) {
      content = content.replaceAll(
        RegExp(r'compileSdkVersion \d+'),
        'compileSdkVersion $compileSdkVersion',
      );
    }

    await buildFile.writeAsString(content);
  }
}
