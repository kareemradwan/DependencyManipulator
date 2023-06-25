import '../plugin/android_plugin.dart';
import 'android_library.dart';

abstract class AndroidLibraryInterface {
  Future<List<AndroidLibrary>> listLibraries();

  Future<AndroidLibrary> getLibrary(String name, String version);

  Future<List<AndroidLibrary>> getLibraries(String name);

  Future<void> updateLibrary(AndroidLibrary library);

  Future<void> removeLibrary(AndroidLibrary library);

  Future<void> addLibrary(AndroidLibrary library);

  Future<void> applyPlugin(AndroidPlugin plugin);
}
