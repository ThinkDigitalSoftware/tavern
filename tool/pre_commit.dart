import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

///
/// Not in use yet. Can't save variables because of a filesystemError. Putting this on pause.
///
main(List<String> arguments) async {
  exit(0); //  exiting now to disable the remaining code.

  File pubspecFile = File('pubspec.yaml');
  YamlMap pubspec = loadYaml(pubspecFile.readAsStringSync());

  var currentVersion = pubspec['version'];
  var file = File('/tool/variables.json');
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  Map data = {};
  var oldVersion;
  if (await file.exists()) {
    data = json.decode(file.readAsStringSync());
    oldVersion = data['version'];
  }
  if (oldVersion == currentVersion) {
    stderr.write('You should increment the version before committing ');
    String answer = stdin.readLineSync();
    if (answer.toLowerCase().startsWith('y')) {
      stderr.write('New version: ');
      String answer = stdin.readLineSync();
      Version version;
      try {
        version = Version.parse(answer);
      } on Exception {}
      while (version == null) {
        stdout.writeln(
            "Sorry, this isn't a valid version. Please enter a valid version number: ");
      }
    }
  }
  var sink = file.openWrite();
  file.writeAsStringSync(jsonEncode({'version': currentVersion}));
  await sink.close();
  exit(0);
}
