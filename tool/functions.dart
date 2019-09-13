import 'dart:developer';
import 'dart:io';

import 'package:pubspec/pubspec.dart';

ProcessResult addFileToCommit(String path) =>
    Process.runSync("git", ["add", path]);

bool hasDependencyOverrides(PubSpec pubspec) {
  if (pubspec.dependencyOverrides.isNotEmpty) {
    log("Dependency overrides: ${pubspec.dependencyOverrides}");
    return true;
  } else {
    return false;
  }
}
