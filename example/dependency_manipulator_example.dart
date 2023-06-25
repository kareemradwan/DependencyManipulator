import 'dart:io';

import 'package:dependency_manipulator/platforms/android/android.dart';
import 'package:dependency_manipulator/platforms/flutter/flutter.dart';

Future<void> main() async {
  var androidPath = 'ANDROID_PATH';
  var androidDirectory = Directory(androidPath);

  var androidManager = AndroidManager(androidDirectory);
  List<AndroidLibrary> androidLibraries = await androidManager.listLibraries();
  List<AndroidPlugin> androidPlugins = await androidManager.listPlugins();
  AndroidManifest manifest =  await androidManager.getManifest();

  await androidManager.prepareEnv();
  await androidManager.applyPlugin(AndroidPlugin("com.google.gms.google-services", "4.3.5"));
  await androidManager.addLibrary(AndroidLibrary("com.gsm.services", version: "2.3"));
  await androidManager.addLibrary(BomAndroidLibrary("com.gsm.services", "1234"));
  bool success = await androidManager.build();



  var pubspecFile = File('./pubspec.yaml');
  var flutterManager = FlutterManager(pubspecFile);
  await flutterManager.addDependency(FlutterDependency("lints", "^2.0.0"));
  var flutterDependencies = await flutterManager.listDependencies(name: "args");
  for (var depedency in flutterDependencies) {
    print("dependency: ${depedency.name} version: ${depedency.version} ");
  }

}
