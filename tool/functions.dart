import 'dart:io';

import 'package:pubspec/pubspec.dart';

ProcessResult addFileToCommit(String path) =>
    Process.runSync("git", ["add", path]);

bool hasDependencyOverrides(PubSpec pubspec) {
  if (pubspec.dependencyOverrides.isNotEmpty) {
    print("[INFO] Dependency overrides: ${pubspec.dependencyOverrides}");
    return true;
  } else {
    return false;
  }
}

Directory currentDirectory = Directory.current;

Future<PubSpec> getPubspec() async => PubSpec.load(currentDirectory);

bool changelogUpdated() {
  ProcessResult results =
      Process.runSync('git', parseCommand('git diff-index --name-status HEAD'));
  final List<String> modifiedFiles = results.stdout.toString().split('\n');
  return modifiedFiles.contains('M	CHANGELOG.md');
}

int numOfGitCommits() {
  ProcessResult results =
      Process.runSync('git', ['rev-list', 'master', '--count']);
  return int.parse(results.stdout);
}

bool changelogHasEntryForVersion(dynamic version) {
  String changelog = File('CHANGELOG.MD').readAsStringSync();
  return changelog.contains(version.toString());
}

List<String> parseCommand(String input) {
  var result = input.split(' ');
  return result.sublist(1);
}
