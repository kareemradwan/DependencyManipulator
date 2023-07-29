import 'dart:io';

import 'android_file_interface.dart';

class AndroidFileManager implements AndroidFileInterface {
  final Directory _android;

  AndroidFileManager(this._android);

  @override
  Future<void> renameDirectory(String oldPath, String newPath) async {
    final oldParts = oldPath.split('/');
    final newParts = newPath.split('/');

    if (oldParts.length != newParts.length) {
      throw ArgumentError('The old and new paths must have the same structure');
    }

    for (var i = 0; i < oldParts.length; i++) {
      final oldDirectory =
          Directory(_android.path + oldParts.sublist(0, i + 1).join('/'));
      final newDirectoryPath =
          '${_android.path}${oldParts.sublist(0, i).join('/')}/${newParts[i]}';

      if (!(await oldDirectory.exists())) {
        throw FileSystemException(
            "Source directory does not exist!", oldDirectory.path);
      }

      await oldDirectory.rename(newDirectoryPath);
      oldParts[i] = newParts[i];
    }
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
