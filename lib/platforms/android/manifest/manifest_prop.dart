import 'package:xml/xml.dart';

class ManifestProp {
  final String key;
  final String value;

  const ManifestProp(this.key, this.value);

  static ManifestProp parse(XmlAttribute attr) {
    ManifestProp prop = ManifestProp(attr.qualifiedName, attr.value);
    return prop;
  }

  static XmlAttribute toXml(ManifestProp prop) {
    return XmlAttribute(XmlName(prop.key), prop.value);
  }

  @override
  String toString() {
    return 'ManifestProp{key: $key, value: $value}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ManifestProp && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
