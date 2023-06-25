import 'dart:io';

import 'pubspec/dependency/flutter_dependency.dart';
import 'pubspec/dependency/flutter_dependency_interface.dart';
import 'pubspec/dependency/flutter_dependency_manager.dart';

class FlutterManager implements FlutterDependencyInterface {
  final File _basePath;
  late FlutterDependencyManager _dependencyManager;

  FlutterManager(this._basePath) {
    _dependencyManager = FlutterDependencyManager(_basePath);
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
  Future<void> pubGet() async {
    // TODO: implement pubGet
    return await _dependencyManager.pubGet();
  }
}
