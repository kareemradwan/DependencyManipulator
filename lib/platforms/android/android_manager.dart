import 'dart:io';

import 'builds/android_build_interface.dart';
import 'builds/android_build_manager.dart';
import 'library/android_library.dart';
import 'library/android_library_interface.dart';
import 'library/android_library_manager.dart';
import 'manifest/android_manifest.dart';
import 'manifest/manifest_interface.dart';
import 'manifest/manifest_manager.dart';
import 'plugin/android_plugin.dart';
import 'manifest/manifest_node.dart';
import 'plugin/android_plugin_interface.dart';
import 'plugin/android_plugin_manager.dart';

class AndroidManager
    implements
        AndroidPluginInterface,
        AndroidLibraryInterface,
        ManifestInterface,
        AndroidBuildInterface {
  late final Directory _android;
  late final AndroidPluginInterface _pluginManager;
  late final AndroidLibraryInterface _libraryManager;
  late final ManifestInterface _manifestManager;
  late final AndroidBuildInterface _buildManager;

  AndroidManager(this._android) {
    var pluginBuildFile = File("${_android.path}/build.gradle");
    if (!pluginBuildFile.existsSync()) {
      throw ArgumentError("file build.gradle is missing inside android folder");
    }
    _pluginManager = AndroidPluginManager(pluginBuildFile);

    var libraryBuildFile = File("${_android.path}/app/build.gradle");
    if (!libraryBuildFile.existsSync()) {
      throw ArgumentError(
          "file build.gradle is missing inside android/app/ folder");
    }
    _libraryManager = AndroidLibraryManager(libraryBuildFile);

    final mainManifestFile =
        File("${_android.path}/app/src/main/AndroidManifest.xml");
    final debugManifestFile =
        File("${_android.path}/app/src/debug/AndroidManifest.xml");
    final profileManifestFile =
        File("${_android.path}/app/src/profile/AndroidManifest.xml");

    final manifestFiles = {
      "main": mainManifestFile,
      "debug": debugManifestFile,
      "profile": profileManifestFile,
    };
    for (final manifestFileEntry in manifestFiles.entries) {
      if (!manifestFileEntry.value.existsSync()) {
        throw ArgumentError(
            "file ${manifestFileEntry.value.path} is missing inside android/app/src/${manifestFileEntry.key}/ folder");
      }
    }
    _manifestManager = ManifestManager(manifestFiles);

    _buildManager = AndroidBuildManager(_android);
  }

  @override
  Future<void> addPlugin(AndroidPlugin plugin) async {
    return await _pluginManager.addPlugin(plugin);
  }

  @override
  Future<AndroidPlugin> getPlugin(String name, String version) async {
    return await _pluginManager.getPlugin(name, version);
  }

  @override
  Future<List<AndroidPlugin>> getPlugins(String name) async {
    return await _pluginManager.getPlugins(name);
  }

  @override
  Future<List<AndroidPlugin>> listPlugins() async {
    return await _pluginManager.listPlugins();
  }

  @override
  Future<void> removePlugin(AndroidPlugin plugin) async {
    return await _pluginManager.removePlugin(plugin);
  }

  @override
  Future<void> updatePlugin(AndroidPlugin plugin) async {
    return await _pluginManager.updatePlugin(plugin);
  }

  @override
  Future<List<AndroidLibrary>> listLibraries() async {
    return await _libraryManager.listLibraries();
  }

  @override
  Future<AndroidLibrary> getLibrary(String name, String version) async {
    return await _libraryManager.getLibrary(name, version);
  }

  @override
  Future<List<AndroidLibrary>> getLibraries(String name) async {
    return await _libraryManager.getLibraries(name);
  }

  @override
  Future<void> updateLibrary(AndroidLibrary library) async {
    return await _libraryManager.updateLibrary(library);
  }

  @override
  Future<void> removeLibrary(AndroidLibrary library) async {
    return await _libraryManager.removeLibrary(library);
  }

  @override
  Future<void> addLibrary(AndroidLibrary library) async {
    return await _libraryManager.addLibrary(library);
  }

  @override
  Set<AndroidManifest> getManifests() {
    return _manifestManager.getManifests();
  }

  @override
  AndroidManifest getManifest(String manifestFileType) {
    return _manifestManager.getManifest(manifestFileType);
  }

  @override
  Future<void> removeManifestNode(
    String manifestFileType,
    ManifestNode node,
  ) async {
    return await _manifestManager.removeManifestNode(
      manifestFileType,
      node,
    );
  }

  @override
  Future<void> addManifestNodeToParent(
    String manifestFileType,
    ManifestNode parent,
    ManifestNode node,
  ) async {
    return await _manifestManager.addManifestNodeToParent(
      manifestFileType,
      parent,
      node,
    );
  }

  @override
  Future<void> addManifestNodeToRoot(
    String manifestFileType,
    ManifestNode node,
  ) async {
    return await _manifestManager.addManifestNodeToRoot(
      manifestFileType,
      node,
    );
  }

  @override
  Future<void> updateManifestNode(
    String manifestFileType,
    ManifestNode node,
  ) async {
    return await _manifestManager.updateManifestNode(
      manifestFileType,
      node,
    );
  }

  @override
  List<ManifestNode> filterBy(
    String manifestFileType,
    String name, {
    String? parentName,
  }) {
    return _manifestManager.filterBy(
      manifestFileType,
      name,
      parentName: parentName,
    );
  }

  @override
  Future<void> applyPlugin(AndroidPlugin plugin) async {
    return await _libraryManager.applyPlugin(plugin);
  }

  @override
  Future<bool> build() async {
    return await _buildManager.build();
  }

  @override
  Future<void> prepareEnv(
      {String? applicationId,
      String? minSdkVersion,
      String? targetSdkVersion,
      String? compileSdkVersion}) async {
    return await _buildManager.prepareEnv(
        applicationId: applicationId,
        minSdkVersion: minSdkVersion,
        targetSdkVersion: targetSdkVersion,
        compileSdkVersion: compileSdkVersion);
  }
}
