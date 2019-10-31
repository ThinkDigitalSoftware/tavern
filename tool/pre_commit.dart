import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

import 'functions.dart';

main(List<String> arguments) async {
  Directory currentDirectory = Directory.current;
  File pubspecFile = File("${currentDirectory.path}/pubspec.yaml");
  if (!pubspecFile.existsSync()) {
    print('pubspec.yaml not found in ${currentDirectory.path}');
    exit(1);
  }
  Map previousDetails = _getPreviousDetails(currentDirectory);
  PubSpec pubspec = await PubSpec.load(currentDirectory);
  print(
      "Before modifying your pubspec.yaml, a backup has been made at pubspec.yaml.bak in case anything goes wrong.");
  if (hasDependencyOverrides(pubspec)) {
    print(
        "[ERROR] Your pubspec contains the above dependency overrides. Please remove them before committing.");
    exit(1);
  }

  pubspecFile.copySync("${currentDirectory.path}/pubspec.yaml.bak");
  Version currentVersion = pubspec.version;
  Version previousVersion;
  String previousVersionString =
      previousDetails[PreviousDetailKey.currentVersion];

  if (previousVersionString != null) {
    previousVersion = Version.parse(previousVersionString);
  } else {
    previousVersion = currentVersion;
  }

  if (currentVersion <= previousVersion) {
    print("Your current version is set as $currentVersion in your pubspec \n"
        "which is not greater that the previous version: $previousVersion.");

    print('To exit, type "exit"');
    print('To ignore version changes and continue, type "ignore"');

    Version newVersion = await _getNewVersion(previousVersion);
    print("Updating version.");
    pubspec = pubspec.copy(version: newVersion);
    previousDetails[PreviousDetailKey.currentVersion] = newVersion.toString();

    //check changelog before committing changes.
    if (!changelogUpdated() || !changelogHasEntryForVersion(newVersion)) {
      stderr.write('You need to add an entry to CHANGELOG.md to continue.');
      exit(1);
    }
    _writeNewDetails(currentDirectory, newDetails: previousDetails);

    await pubspec.save(currentDirectory);
    print("Update Successful.\n\n");
    print('New pubspec.yaml\n'
        '------');
    print(pubspecFile.readAsStringSync());
    print('------');
    addFileToCommit(pubspecFile.path);
  } else {
    previousDetails[PreviousDetailKey.currentVersion] =
        currentVersion.toString();
    _writeNewDetails(currentDirectory, newDetails: previousDetails);
  }
}

Future<Version> _getNewVersion(Version previousVersion) async {
  Version newVersion;
  String versionString;
  do {
    try {
      versionString = await _getNewVersionString();
      if (versionString.isEmpty) {
        continue;
      }
    } on FileSystemException {
      print("This script must be run from the terminal. Exiting\n");
      exit(1);
    }
    if (versionString.contains('exit')) {
      print('No changes made. Commit will not be run');
      exit(1);
    }
    if (ignoreSpellings.contains(versionString)) {
      print('No changes made. Continuing with commit.');
      exit(0);
    }
    try {
      newVersion = Version.parse(versionString);

      if (newVersion <= previousVersion) {
        print(
            '$versionString is not newer than $previousVersion. Please try again.');
      }
    } catch (e) {
      print('$versionString is not a valid version. Please try again.');
    }
  } while (newVersion == null || newVersion <= previousVersion);
  return newVersion;
}

Future<String> _getNewVersionString() async {
  print('Enter the new version: ');
  try {
    return await input();
  } on Exception {
    final String input = stdin.readLineSync();
    if (input == null) {
      rethrow;
    }
    return input;
  }
}

Future<String> input([String prompt]) {
  if (prompt != null) {
    print(prompt);
  }

  return File(Platform.isWindows ? r'conIN$' : '/dev/tty')
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .first;
}

Map _getPreviousDetails(Directory currentDirectory) {
  File previousDetailsFile =
      File("${currentDirectory.path}/previousDetails.json");
  if (!previousDetailsFile.existsSync()) {
    previousDetailsFile.createSync();
    previousDetailsFile.writeAsStringSync(jsonEncode({}));
  }
  return jsonDecode(previousDetailsFile.readAsStringSync());
}

void _writeNewDetails(Directory currentDirectory, {@required Map newDetails}) {
  File previousDetailsFile =
      File("${currentDirectory.path}/previousDetails.json");
  previousDetailsFile.writeAsStringSync(jsonEncode(newDetails), flush: true);
}

class PreviousDetailKey {
  static const String currentVersion = "currentVersion";
}

final List<String> ignoreSpellings = ['ignore', 'ingore'];
