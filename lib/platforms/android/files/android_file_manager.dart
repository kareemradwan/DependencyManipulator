import 'dart:io';

import 'android_file_interface.dart';

class AndroidFileManager implements AndroidFileInterface {
  final Directory _android;

  AndroidFileManager(this._android);

  @override
  Future<void> renameDirectory(String oldPath, String newPath) async {
    final directory = Directory(_android.path + oldPath);
    final exists = await directory.exists();
    if (!exists) {
      throw ArgumentError("oldPath $directory doesn't exist");
    }
    await directory.rename(_android.path + newPath);
  }

  @override
  Future<void> replaceFileContent(
    String path,
    String oldContent,
    String newContent,
  ) async {
    final file = File(_android.path + path);
    final exists = await file.exists();
    if (!exists) {
      throw ArgumentError("$file doesn't exist");
    }
    var contents = await file.readAsString();
    contents = contents.replaceAll(oldContent, newContent);
    await file.writeAsString(contents);
  }
}
