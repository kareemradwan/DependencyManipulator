import 'dart:io';

import 'package:dependency_manipulator/platforms/flutter/pubspec/config/flutter_configs_interfaces.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterConfigsManager implements FlutterConfigsInterface {
  final File _pubspecFile;
  late YamlEditor _editor;

  FlutterConfigsManager(this._pubspecFile) {
    _editor = YamlEditor(_pubspecFile.readAsStringSync());
  }

  @override
  Future<void> updateName(String name) async {
    if (!_pubspecFile.existsSync()) {
      throw Exception("pubspec.yaml not found");
    }
    final pubspecContent = await _pubspecFile.readAsString();

    final editor = YamlEditor(pubspecContent);
    final oldName = _editor.parseAt(['name']).value;

    editor.update(['name'], name);

    // Write changes back to pubspec.yaml
    await _pubspecFile.writeAsString(editor.toString());

    // Update imports
    await _updateImports(oldName, name);
  }

  Future<void> _updateImports(String oldName, String newName) async {
    final projectDir = Directory('${_pubspecFile.parent.path}/lib');
    final dartFiles = projectDir
        .listSync(recursive: true)
        .where((entity) => entity is File && entity.path.endsWith('.dart'));

    for (final file in dartFiles) {
      var content = await File(file.path).readAsString();
      print('file ${file.path}');
      content = content.replaceAll(
        "import 'package:$oldName/",
        "import 'package:$newName/",
      );
      await File(file.path).writeAsString(content);
    }
  }

  @override
  Future<void> pubGet() async {
    await Process.run("flutter", ["pub", "get"]);
  }

  @override
  Future<void> format() async {
    final projectDir = Directory('${_pubspecFile.parent.path}/lib');
    await Process.run("flutter", ["format",(projectDir.path)]);
  }
}