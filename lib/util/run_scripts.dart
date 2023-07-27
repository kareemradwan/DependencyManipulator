// This function will be able to execute any ruby script and return its output as a list
import 'dart:convert';
import 'dart:io';

Future<List<String>> executeRubyScript(String scriptPath,
    [List<String>? argument]) async {
  final List<String> result = [];

  // Prepare the argument list
  List<String> arguments = ['scripts/ruby/$scriptPath'];
  if (argument != null) {
    arguments.addAll(argument);
  }

  final process = await Process.start(
    'ruby',
    arguments,
  );

  // Transform stdout's Stream<List<int>> to Stream<String>
  final output = process.stdout.transform(Utf8Decoder());

  // Listen for the output
  await for (var data in output) {
    result.add(data);
  }

  // Wait for the process to be finished
  await process.exitCode;

  return result;
}
