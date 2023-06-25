Manipulate you Dependencies as a Game

## Features

List Android Libraries with versions.
Search for Libraries by name and version.
Read Manifest file by code.
Add Android Library.
Remove Android Library.
Update Android Library.

List Android Plugins with versions.
Search for Plugins by name and version.
Add Android Plugin.
Apply Android Plugin.

Build the Project ( gradlew build).

List Flutter Dependencies with versions.
Search for Dependencies by name and version.
Add Flutter Dependencies .

Install Dependencies ( pub get ).

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
var androidPath = 'ANDROID_PATH';
var androidDirectory = Directory(androidPath);

var androidManager = AndroidManager(androidDirectory);
List<AndroidLibrary> androidLibraries = await androidManager.listLibraries();
List<AndroidPlugin> androidPlugins = await androidManager.listPlugins();
AndroidManifest manifest =  await androidManager.getManifest();

await androidManager.prepareEnv();
await androidManager.applyPlugin(AndroidPlugin("com.google.gms.google-services", "4.3.5"));
await androidManager.addLibrary(AndroidLibrary("com.gsm.services", version: "2.3"));
await androidManager.addLibrary(BomAndroidLibrary("com.gsm.services", "1234"));
bool success = await androidManager.build();



var pubspecFile = File('./pubspec.yaml');
var flutterManager = FlutterManager(pubspecFile);
await flutterManager.addDependency(FlutterDependency("lints", "^2.0.0"));
var flutterDependencies = await flutterManager.listDependencies(name: "args");
for (var depedency in flutterDependencies) {
    print("dependency: ${depedency.name} version: ${depedency.version} ");
}

```

## Additional information

draft version