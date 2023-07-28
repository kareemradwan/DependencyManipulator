import 'dart:io';

import 'package:dependency_manipulator/platforms/flutter/flutter_manager.dart';

Future<void> main() async {
  //var androidPath = '/Users/salahamassi/Public/flutter_bond/android';
  // var androidDirectory = Directory(androidPath);
  // print('androidDirectory: ${androidDirectory.path}');
  //
  // var androidManager = AndroidManager(androidDirectory);
  //
  // await androidManager.prepareEnv(
  //   appName: 'salah',
  //   applicationId: 'com.app.ps',
  //   minSdkVersion: '32',
  //   targetSdkVersion: '32',
  //   compileSdkVersion: '44',
  // );
  //
  // final types = ['main', 'debug', 'profile'];
  //
  // for (final type in types) {
  //   final manifest = androidManager.getManifest(type);
  //   final manifestParentNode = manifest.filterByName('manifest').first;
  //   final newProps = manifestParentNode.props
  //     ..remove(
  //       manifestParentNode.props.firstWhere(
  //         (element) => element.key == 'package',
  //       ),
  //     )
  //     ..add(
  //       ManifestProp(
  //         'package',
  //         'ps.app.salah',
  //       ),
  //     );
  //   manifestParentNode.props = newProps;
  //
  //   androidManager.updateManifestNode(
  //     type,
  //     manifestParentNode,
  //   );
  // }
  //
 //  final oldPath = '/app/src/main/kotlin/ps/app/bond';
 //  final newPath = '/app/src/main/kotlin/ps/app/salah';
 //  await androidManager.renameDirectory(oldPath, newPath);
 //  final appClassPath = '/$newPath/MainActivity.kt';
 //  await androidManager.replaceFileContent(
 //    appClassPath,
 //    'package ps.app.bond',
 //    'package ps.app.salah',
 //  );
 // print('build android app ...');

  // var iosPath = '/Users/salahamassi/Public/flutter_bond/ios';
  //
  // final iosManager = IosManager(Directory(iosPath));
  // print('iosManager: ${await iosManager.getAppName()}');
  // final bundleId = await iosManager.getBundleId();
  // print('iosManager: $bundleId');
  //
  // for (final bundle in bundleId.entries) {
  //   print('iosManager: ${bundle.key} ${bundle.value}');
  //   await iosManager.updateBundleId('sa.app.salah', bundle.key);
  // }
  // await iosManager.updateAppName('Salah');

  // bool success = await androidManager.build();
  // print('success: $success');
  //
  final flutterPath = '/Users/salahamassi/Public/flutter_bond';
  final pubspecFile = File('$flutterPath/pubspec.yaml');
  final flutterManager = FlutterManager(pubspecFile);
  await flutterManager.updateName('salah');
  await flutterManager.format();
  await flutterManager.pubGet();
  // await flutterManager.addDependency(FlutterDependency("lints", "^2.0.0"));
  // var flutterDependencies = await flutterManager.listDependencies(name: "args");
  // for (var depedency in flutterDependencies) {
  //   print("dependency: ${depedency.name} version: ${depedency.version} ");
  // }
}
