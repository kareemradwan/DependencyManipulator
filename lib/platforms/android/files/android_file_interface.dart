abstract class AndroidFileInterface {
  Future<void> renameDirectory(
    String oldPath,
    String newPath,
  );

  Future<void> replaceFileContent(
    String path,
    String oldContent,
    String newContent,
  );
}
