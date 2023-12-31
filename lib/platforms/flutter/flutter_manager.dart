import 'dart:io';

import 'package:native_project_manipulator/platforms/flutter/pubspec/config/flutter_configs_manager.dart';
import 'package:native_project_manipulator/platforms/flutter/pubspec/config/flutter_configs_interfaces.dart';

import 'pubspec/dependency/flutter_dependency.dart';
import 'pubspec/dependency/flutter_dependency_interface.dart';
import 'pubspec/dependency/flutter_dependency_manager.dart';

class FlutterManager
    implements FlutterDependencyInterface, FlutterConfigsInterface {
  final Directory _projectDirectory;
  late FlutterDependencyInterface _dependencyManager;
  late FlutterConfigsInterface _flutterConfigs;

  FlutterManager(this._projectDirectory, {bool printToConsole = true}) {
    final pubspecFile = File('${_projectDirectory.path}/pubspec.yaml');
    _dependencyManager = FlutterDependencyManager(pubspecFile);
    _flutterConfigs = FlutterConfigsManager(pubspecFile, printToConsole);
  }

  @override
  Future<void> addDependency(FlutterDependency dependency) async {
    return await _dependencyManager.addDependency(dependency);
  }

  @override
  Future<List<FlutterDependency>> listDependencies(
      {String? name, String? version}) async {
    return await _dependencyManager.listDependencies(
        name: name, version: version);
  }

  @override
  Future<void> remove(FlutterDependency dependency) async {
    return await _dependencyManager.remove(dependency);
  }

  @override
  Future<void> update(FlutterDependency dependency) async {
    return await _dependencyManager.update(dependency);
  }

  @override
  Future<void> format() async {
    await _flutterConfigs.format();
  }

  @override
  Future<void> pubGet() async {
    await _flutterConfigs.pubGet();
  }

  @override
  Future<void> updateName(String name) async {
    await _flutterConfigs.updateName(name);
  }
}
