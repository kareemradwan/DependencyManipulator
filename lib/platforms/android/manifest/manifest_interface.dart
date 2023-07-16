import 'android_manifest.dart';
import 'manifest_node.dart';

abstract class ManifestInterface {
  Set<AndroidManifest> getManifests();

  AndroidManifest getManifest(String manifestFileType);

  Future<void> addManifestNodeToRoot(
    String manifestFileType,
    ManifestNode node,
  );

  Future<void> addManifestNodeToParent(
    String manifestFileType,
    ManifestNode parent,
    ManifestNode node,
  );

  Future<void> updateManifestNode(
    String manifestFileType,
    ManifestNode node,
  );

  Future<void> removeManifestNode(
    String manifestFileType,
    ManifestNode node,
  );

  List<ManifestNode> filterBy(
    String manifestFileType,
    String name, {
    String? parentName,
  });
}
