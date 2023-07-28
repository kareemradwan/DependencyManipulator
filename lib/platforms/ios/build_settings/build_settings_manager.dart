import 'dart:convert';
import 'dart:io';

import 'package:dependency_manipulator/util/run_scripts.dart';
import 'package:xml/xml.dart';

import 'build_settings_interface.dart';

class BuildSettingsManager implements BuildSettingsInterface {
  final Directory iosDirectory;

  BuildSettingsManager(this.iosDirectory);

  File get _infoPlist => File("${iosDirectory.path}/Runner/Info.plist");

  File get _buildSettingsFile => File("${iosDirectory.path}/Runner.xcodeproj");

  @override
  Future<String> getAppName() async {
    // Check if file exists
    if (!_infoPlist.existsSync()) {
      throw Exception('Info.plist file not found at ${_infoPlist.path}');
    }

    // Read the file
    final document = XmlDocument.parse(await _infoPlist.readAsString());

    // Find the key and get the following string element
    final appNameElement = document
        .findAllElements('key')
        .firstWhere((element) => element.text == 'CFBundleDisplayName')
        .nextElementSibling;

    if (appNameElement == null) {
      throw Exception('CFBundleName not found in Info.plist file');
    }

    // Return the appName
    return appNameElement.text;
  }

  @override
  Future<Map<String, dynamic>> getBundleId() async {
    final output = await executeRubyScript(
      'get_bundle_id.rb',
      [_buildSettingsFile.path],
    );
    if (output.isEmpty) {
      throw Exception('No bundle ID found');
    }
    final bundleId = jsonDecode(output.first);
    return bundleId;
  }

  @override
  Future<void> setAppName(String appName) async {
    // Check if file exists
    if (!_infoPlist.existsSync()) {
      throw Exception('Info.plist file not found at ${_infoPlist.path}');
    }

    // Read the file
    final document = XmlDocument.parse(_infoPlist.readAsStringSync());

    // Find the key and get the following string element
    final appNameElement = document
        .findAllElements('key')
        .firstWhere((element) => element.text == 'CFBundleName')
        .nextElementSibling;

    if (appNameElement == null) {
      throw Exception('CFBundleName not found in Info.plist file');
    }

    // Set the new app name
    appNameElement.innerText = appName.toLowerCase().replaceAll(' ', '_');

    final appDisplayNameElement = document
        .findAllElements('key')
        .firstWhere((element) => element.text == 'CFBundleDisplayName')
        .nextElementSibling;

    if (appDisplayNameElement == null) {
      throw Exception('CFBundleDisplayName not found in Info.plist file');
    }

    // Set the new app display name
    appDisplayNameElement.innerText = appName;

    // Write the file
    _infoPlist.writeAsStringSync(document.toXmlString(pretty: true));
  }

  @override
  Future<void> setBundleId(String bundleId, String buildConfig) async {
    final output = await executeRubyScript(
      'set_bundle_id.rb',
      [
        _buildSettingsFile.path,
        bundleId,
        buildConfig,
      ],
    );
    if (output.isEmpty) {
      throw Exception('Failed to set bundle ID');
    }
    print('output: ${output.join()}');
  }
}
