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
