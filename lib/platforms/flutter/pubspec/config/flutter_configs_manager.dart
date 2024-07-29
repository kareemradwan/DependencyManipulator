import 'dart:io';

import 'package:native_project_manipulator/platforms/flutter/pubspec/config/flutter_configs_interfaces.dart';
import 'package:yaml_edit/yaml_edit.dart';

class FlutterConfigsManager implements FlutterConfigsInterface {
  final File _pubspecFile;
  final bool _printToConsole;
  late YamlEditor _editor;

  FlutterConfigsManager(this._pubspecFile, this._printToConsole) {
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
      content = content.replaceAll(
        "import 'package:$oldName/",
        "import 'package:$newName/",
      );
      content = content.replaceAll(
        "export 'package:$oldName/",
        "export 'package:$newName/",
      );
      await File(file.path).writeAsString(content);
    }
  }

  @override
  Future<void> pubGet() async {
    final projectDir = Directory(_pubspecFile.parent.path);
    final originalWorkingDirectory = Directory.current;

    try {
      Directory.current = projectDir.path;
      final pubGetProcessResult = await Process.run('flutter', ['pub', 'get']);

      if (pubGetProcessResult.exitCode != 0) {
        throw Exception(
            'Failed to run flutter pub get: ${pubGetProcessResult.stderr}');
      }
      if (_printToConsole) {
        stdout.write(pubGetProcessResult.stdout);
      }
      stderr.write(pubGetProcessResult.stderr);
    } finally {
      Directory.current = originalWorkingDirectory;
    }
  }

  @override
  Future<void> format() async {
    final projectDir = Directory('${_pubspecFile.parent.path}/lib');
    final exists = await projectDir.exists();
    if (!exists) {
      throw Exception('lib directory not found');
    }
    final originalWorkingDirectory = Directory.current;
    try {
      Directory.current = projectDir.path;
      final formatProcessResult = await Process.run('dart', [
        'format',
        projectDir.path,
      ]);

      if (_printToConsole) {
        stdout.write(formatProcessResult.stdout);
      }
    } finally {
      Directory.current = originalWorkingDirectory;
    }
  }
}
