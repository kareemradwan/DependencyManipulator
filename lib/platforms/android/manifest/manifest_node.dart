import 'package:xml/xml.dart';

import 'manifest_prop.dart';

class ManifestNode {
  final String uuid = "${DateTime.now().microsecondsSinceEpoch}";
  final String title;
  List<ManifestNode> _children;
  List<ManifestProp> _props;

  ManifestNode? _parent;

  ManifestNode(this.title, this._children, this._props);

  static ManifestNode parse(XmlElement element) {
    List<ManifestNode> children = [];
    List<ManifestProp> props = [];

    var node = ManifestNode(element.qualifiedName, children, props);
    for (var element in element.childElements) {
      ManifestNode child = ManifestNode.parse(element);
      child._parent = node;
      children.add(child);
    }

    for (var element in element.attributes) {
      ManifestProp prop = ManifestProp.parse(element);
      props.add(prop);
    }

    return node;
  }

  void add(ManifestNode node) {
    _children.add(node);
  }

  List<ManifestNode> filterBy(ManifestNode node) {
    var lst = _children.where((element) => element.uuid == node.uuid).toList();
    for (var item in _children) {
      lst.addAll(item.filterBy(node));
    }
    return lst;
  }

  List<ManifestNode> filterByName(String name, {String? parentName}) {
    var lst = _children
        .where((element) =>
            element.title == name &&
            ((parentName == null || element._parent == null) ||
                (parentName == element._parent?.title)))
        .toList();
    for (var item in _children) {
      lst.addAll(item.filterByName(name, parentName: parentName));
    }
    return lst;
  }

  void remove(ManifestNode remove) {
    _children.removeWhere((element) => element.uuid == remove.uuid);
    for (var element in _children) {
      element.remove(element);
    }
  }

  static XmlElement toXml(ManifestNode node) {
    List<XmlAttribute> attrs =
        node._props.map((e) => ManifestProp.toXml(e)).toList();
    List<XmlElement> children =
        node._children.map((e) => ManifestNode.toXml(e)).toList();

    XmlElement element = XmlElement(XmlName(node.title), attrs, children);
    return element;
  }

  void update(ManifestNode node) {
    _children = node._children;
    _props = node._props;
  }

  @override
  String toString() {
    return 'ManifestNode{title: $title, childs: $_children, props: $_props}';
  }
}
