import 'dart:developer';
import 'dart:io';

import '../../../../util/console.dart';
import '../../../../util/file.dart';
import '../plugin/android_plugin.dart';
import 'android_library.dart';
import 'android_library_interface.dart';

class AndroidLibraryManager implements AndroidLibraryInterface {
  final File buildFile;
  final Map<int, AndroidLibrary> _cache = {};

  AndroidLibraryManager(this.buildFile);

  @override
  Future<List<AndroidLibrary>> listLibraries() async {
    _cache.clear();
    var result = await buildFile.search("implementation");

    if (result.isEmpty) {
      return [];
    }
    final List<AndroidLibrary> libs = [];
    for (final element in result) {

      final rawLibrary = element.line
          .trim()
          .replaceAll("implementation ", "")
          .replaceAll("'", "")
          .replaceAll('"', '');

      if (rawLibrary != '') {
        final parts = rawLibrary.split(":");
        var libraryVersion = parts.removeLast();
        final libraryName = parts.join(":");

        if (libraryVersion.startsWith("\$")) {
          final resolveVersionResult = await buildFile
              .search("ext.${libraryVersion.replaceAll("\$", "")}");
          if (resolveVersionResult.isNotEmpty) {
            final version = resolveVersionResult[0]
                .line
                .replaceAll("ext.${libraryVersion.replaceAll("\$", "")} = ", "")
                .replaceAll("'", "")
                .replaceAll('"', '');
            libraryVersion = version;
          }
        }

        final library =
            AndroidLibrary(libraryName, version: libraryVersion.trim());
        libs.add(library);
        _cache[element.index] = library;
      }
    }

    return libs;
  }

  @override
  Future<AndroidLibrary> getLibrary(String name, String? version) async {
    await listLibraries();
    var items = _cache.values
        .where((element) => element.name == name && element.version == version);

    if (items.isEmpty) {
      throw Exception(
          "No Android Library found with name: ${name} and version: ${version}");
    }
    return items.first;
  }

  @override
  Future<List<AndroidLibrary>> getLibraries(String name) async {
    await listLibraries();

    var items = _cache.values.where((element) => element.name == name).toList();
    if (items.isEmpty) {
      throw Exception("No Android Library found with name: ${name}");
    }
    return items;
  }

  @override
  Future<void> updateLibrary(AndroidLibrary library) async {
    List<SearchResult> result = [];
    result = await buildFile.search("dependencies");
    if (result.isEmpty) {
      throw Exception("No libraries tag into /android/app/build.gradle");
    }
    await listLibraries();

    var libraryIndex = -1;
    for (var element in _cache.entries) {
      if (element.value.name == library.name &&
          element.value.version?.trim() == library.version?.trim()) {
        libraryIndex = element.key;
        break;
      }
    }

    if (libraryIndex == -1) {
      printWarning("No Android Library Matched ");
      return;
    }

    Map<int, String> linesIndex = await buildFile.linesIndexed();

    String content = "";
    linesIndex.forEach((key, value) {
      if (key != libraryIndex) {
        content += '    implementation "${library.name}:${library.version}"\n';
      }
    });

    buildFile.writeAsStringSync(content);
  }

  @override
  Future<void> removeLibrary(AndroidLibrary library) async {
    List<SearchResult> result = [];
    result = await buildFile.search("dependencies");
    if (result.isEmpty) {
      throw Exception("No dependencies tag into /android/build.gradle");
    }
    await listLibraries();
    var libraryIndex = -1;
    for (var element in _cache.entries) {
      if (element.value.name == library.name &&
          element.value.version?.trim() == library.version?.trim()) {
        libraryIndex = element.key;
        break;
      }
    }

    if (libraryIndex == -1) {
      printWarning("No Android Library Matched ");
      return;
    }

    Map<int, String> linesIndex = await buildFile.linesIndexed();

    String content = "";
    linesIndex.forEach((key, value) {
      if (key != libraryIndex) {
        content += "$value\n";
      }
    });

    buildFile.writeAsStringSync(content);
  }

  @override
  Future<void> addLibrary(AndroidLibrary library) async {
    List<SearchResult> result = [];

    try {
      await listLibraries();
      await getLibrary(library.name, library.version);
      return;
    } catch (error) {}

    result = await buildFile.search("dependencies");
    Map<int, String> linesIndex = await buildFile.linesIndexed();
    var content = "";
    if (result.isEmpty) {
      linesIndex.forEach((key, value) {
        content += "$value\n";
      });
      content += "dependencies {\n";
      content += library.toGradle();
      content += "}";
    } else {
      linesIndex.forEach((key, value) {
        if (key == result[0].index + 1) {
          content += library.toGradle();
        }
        content += "$value\n";
      });
    }
    buildFile.writeAsStringSync(content);
  }

  @override
  Future<void> applyPlugin(AndroidPlugin plugin) async {
    var result = await buildFile.search("apply plugin:");
    if (result.isEmpty) {
      return;
    }

    var insertedIndex = result.last.index;
    Map<int, String> linesIndex = await buildFile.linesIndexed();

    for (var element in linesIndex.values) {
      if (element.contains("apply") && element.contains(plugin.name)) {
        return;
      }
    }

    var content = "";
    linesIndex.forEach((key, value) {
      if (key == insertedIndex) {
        content += "${plugin.apply()}\n";
      }
      content += "$value\n";
    });
    buildFile.writeAsStringSync(content);
  }
}
