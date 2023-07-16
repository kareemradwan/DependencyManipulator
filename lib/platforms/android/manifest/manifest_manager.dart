import 'dart:io';

import 'android_manifest.dart';
import 'manifest_interface.dart';
import 'manifest_node.dart';
import 'package:xml/xml.dart';

class ManifestManager implements ManifestInterface {
  final Map<String, File> manifestFiles;
  final Map<String, AndroidManifest> _manifest = {};

  ManifestManager(this.manifestFiles) {
    for (final manifestFileEntry in manifestFiles.entries) {
      final manifestFile = manifestFileEntry.value;
      final document = XmlDocument.parse(manifestFile.readAsStringSync());
      XmlElement? applicationElement = document.getElement("manifest");
      if (applicationElement == null) {
        throw Exception("Invalid manifest file");
      }
      final application = ManifestNode.parse(applicationElement);
      final model = AndroidManifest(application);
      _manifest[manifestFileEntry.key] = model;
    }
  }

  @override
  Set<AndroidManifest> getManifests() {
    return _manifest.values.toSet();
  }

  @override
  AndroidManifest getManifest(String manifestFileType) {
    if (!_manifest.containsKey(manifestFileType)) {
      throw Exception(
        "Manifest file for type $manifestFileType not found",
      );
    }
    return _manifest[manifestFileType]!;
  }

  @override
  Future<void> removeManifestNode(
    String manifestFileType,
    ManifestNode node,
  ) async {
    var manifest = getManifest(manifestFileType);
    manifest.remove(node);
    if (!manifestFiles.containsKey(manifestFileType)) {
      throw Exception(
        "Manifest file for type $manifestFileType not found",
      );
    }
    manifestFiles[manifestFileType]!.writeAsStringSync(manifest.toXml());
  }

  @override
  Future<void> addManifestNodeToParent(
    String manifestFileType,
    ManifestNode parent,
    ManifestNode node,
  ) async {
    var manifest = getManifest(manifestFileType);
    // parent.add(node);
    var result = manifest.filterBy(parent)[0];
    result.add(node);
    if (!manifestFiles.containsKey(manifestFileType)) {
      throw Exception(
        "Manifest file for type $manifestFileType not found",
      );
    }
    manifestFiles[manifestFileType]!.writeAsStringSync(manifest.toXml());
  }

  @override
  Future<void> addManifestNodeToRoot(
    String manifestFileType,
    ManifestNode node,
  ) async {
    var manifest = getManifest(manifestFileType);
    manifest.add(node);
    if (!manifestFiles.containsKey(manifestFileType)) {
      throw Exception(
        "Manifest file for type $manifestFileType not found",
      );
    }
    manifestFiles[manifestFileType]!.writeAsStringSync(manifest.toXml());
  }

  @override
  Future<void> updateManifestNode(
    String manifestFileType,
    ManifestNode node,
  ) async {
    var manifest = getManifest(manifestFileType);
    var result = manifest.filterBy(node);
    if (result.length == 1) {
      ManifestNode preNode = result[0];
      preNode.update(node);
      if (!manifestFiles.containsKey(manifestFileType)) {
        throw Exception(
          "Manifest file for type $manifestFileType not found",
        );
      }
      manifestFiles[manifestFileType]!.writeAsStringSync(manifest.toXml());
    }
  }

  @override
  List<ManifestNode> filterBy(
    String manifestFileType,
    String name, {
    String? parentName,
  }) {
    var manifest = getManifest(manifestFileType);
    return manifest.filterByName(name, parentName: parentName);
  }
}
