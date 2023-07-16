import 'dart:io';

import 'package:dependency_manipulator/platforms/android/android.dart';

Future<void> main() async {
  var androidPath = '/Users/salahamassi/Public/flutter_bond/android';
  var androidDirectory = Directory(androidPath);
  print('androidDirectory: ${androidDirectory.path}');

  var androidManager = AndroidManager(androidDirectory);
  List<AndroidLibrary> androidLibraries = await androidManager.listLibraries();
  List<AndroidPlugin> androidPlugins = await androidManager.listPlugins();

  await androidManager.prepareEnv(
    applicationId: 'com.app.ps',
    minSdkVersion: '32',
    targetSdkVersion: '32',
    compileSdkVersion: '44',
  );

  // await androidManager
  //     .applyPlugin(AndroidPlugin("com.google.gms.google-services", "4.3.5"));
  // await androidManager
  //     .addLibrary(AndroidLibrary("com.gsm.services", version: "2.3"));
  // await androidManager
  //     .addLibrary(BomAndroidLibrary("com.gsm.services", "1234"));

  final types = ['main', 'debug', 'profile'];

  for (final type in types) {
    final manifest = androidManager.getManifest(type);
    final manifestParentNode = manifest.filterByName('manifest').first;
    final newProps = manifestParentNode.props
      ..remove(
        manifestParentNode.props.firstWhere(
          (element) => element.key == 'package',
        ),
      )
      ..add(
        ManifestProp(
          'package',
          'ps.app.salah',
        ),
      );
    manifestParentNode.props = newProps;

    androidManager.updateManifestNode(
      type,
      manifestParentNode,
    );
  }
  print('build android app ...');

  // bool success = await androidManager.build();
  // print('success: $success');
  //
  // var pubspecFile = File('./pubspec.yaml');
  // var flutterManager = FlutterManager(pubspecFile);
  // await flutterManager.addDependency(FlutterDependency("lints", "^2.0.0"));
  // var flutterDependencies = await flutterManager.listDependencies(name: "args");
  // for (var depedency in flutterDependencies) {
  //   print("dependency: ${depedency.name} version: ${depedency.version} ");
  // }
}
