import 'dart:io';

import 'package:github/github.dart';

import 'functions.dart';
import 'package:args/args.dart';

Future main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addFlag('no-build',
      abbr: 'n',
      help:
          "Skips the compilation step. Useful if you're reuploading manuallly.",
      defaultsTo: false);

  final ArgResults argResults = argsParser.parse(args);

  Map<String, String> envVars = Platform.environment;
  final githubToken = envVars['GITHUB_TOKEN'];
  if (githubToken == null) {
    print('github token is not set. exiting');
    exit(0);
  }

  final github = GitHub(auth: Authentication.withToken(githubToken));
  final tavernRepositorySlug = RepositorySlug('thinkdigitalsoftware', 'tavern');

  final repositoriesService = RepositoriesService(github);
  final pubspec = await getPubspec();
  final tag = pubspec.version.toString();
  final lastCommitMessage =
      Process.runSync('git', ['log', '-1', '--pretty=%B']).stdout;
  final createRelease = CreateRelease.from(
    tagName: tag,
    name: tag,
    isDraft: false,
    targetCommitish: "master",
    isPrerelease: false,
    body: lastCommitMessage.toString(),
  );

  if (!argResults['no-build']) {
    _buildReleaseAssets();
  }

  Release release = await getRelease(
      repositoriesService, tavernRepositorySlug, createRelease);
  if (release == null) {
    stderr.writeln('Failed to create new release.');
    exit(1);
  }
  await uploadExistingApks(repositoriesService, release);

  exit(0);
}

void _buildReleaseAssets() {
  print('Building release assets. This may take a while, but it is running.');
  ProcessResult result;
  result = Process.runSync(
    'flutter',
    ['build', 'apk', '--split-per-abi'],
  );
  print(result.stdout);
}

Future uploadExistingApks(
    RepositoriesService repositoriesService, Release release) async {
  String buildDirectoryPath =
      "${Directory.current.path}/build/app/outputs/apk/release/";
  final buildDirectory = Directory(buildDirectoryPath);
  if (!buildDirectory.existsSync()) {
    stderr.write(
        '[ERROR] $buildDirectory does not exist. Assets cannot be uploaded to the release. Exiting.');
    exit(1);
  }

  final apksInDir =
      buildDirectory.listSync().where((entity) => entity.path.endsWith('apk'));

  Iterable createReleaseAssets = apksInDir.map<CreateReleaseAsset>((apk) {
    String fileName = apk.path.substring(apk.path.lastIndexOf('/') + 1);
    return CreateReleaseAsset(
        name: fileName,
        assetData: File(apk.path).readAsBytesSync(),
        contentType: "application/vnd.android.package-archive");
  });
  final List<ReleaseAsset> releaseAssets = await repositoriesService
      .uploadReleaseAssets(release, createReleaseAssets);
  stdout.write('Upload Complete for ${release.tagName}\n'
      'Url: ${release.url}\n');
}

Future<Release> getRelease(RepositoriesService repositoriesService,
    RepositorySlug tavernRepositorySlug, CreateRelease createRelease) async {
  Release release;

  int retryCount = 2;
  do {
    try {
      release = await repositoriesService.createRelease(
        tavernRepositorySlug,
        createRelease,
      );
    } catch (e) {}
    retryCount--;
  } while (release == null && retryCount > 0);
  return release;
}
