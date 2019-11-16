import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:github/github.dart' as gitHub;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';

import '../bloc.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  final PubHtmlParsingClient client;
  final FullPackageRepository _packageRepository =
      GetIt.instance.get<FullPackageRepository>();
  gitHub.GitHub _gitHub;

  @override
  SubscriptionState get initialState =>
      super.initialState ?? InitialSubscriptionState();

  SubscriptionBloc({@required this.client}) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
            onDidReceiveLocalNotification); // TODO: implement
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification); // TODO: implement
    // bloc's state is loaded by this point. So we can access the packages.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
        ), () {
      checkForUpdates(state.subscribedPackages).then((updatedPackages) {
        debugPrint(
            'Notifying user of updates to ${updatedPackages.length} packages.');
      });
    });
  }

  @override
  Stream<SubscriptionState> mapEventToState(
    SubscriptionEvent event,
  ) async* {
    if (event is AddSubscription) {
      yield state.withSubscription(event.subscription);
    } else if (event is AddSubscription) {
      yield state.withSubscription(event.subscription);
    } else if (event is RemoveSubscription) {
      yield state.withoutSubscription(event.subscription);
    } else if (event is RemoveSubscription) {
      yield state.withoutSubscription(event.subscription);
    } else if (event is GetGitHubStars) {
      final settingsState = SettingsBloc.of(event.context).state;
      if (settingsState.isAuthenticated) {
        List<FullPackage> gitHubStarredPackages = [];

        _gitHub ??= gitHub.GitHub(auth: settingsState.authentication);
        for (final subscribedPackage in state.subscribedPackages) {
          final repositoryUrl = subscribedPackage.repositoryUrl;
          if (repositoryUrl?.contains('github') ?? false) {
            List<String> urlParts = repositoryUrl.split('/');
            final githubUrlIndex = urlParts
                .lastIndexWhere((urlPart) => urlPart.contains('github.com'));
            String owner;
            String name;

            if (urlParts.length < githubUrlIndex + 2) {
              continue; // skip
            }
            owner = urlParts[githubUrlIndex + 1];
            name = urlParts[githubUrlIndex + 2];

            gitHub.RepositorySlug repositorySlug =
                gitHub.RepositorySlug(owner, name);
            bool isStarred = await _gitHub.activity.isStarred(repositorySlug);
            if (isStarred) {
              gitHubStarredPackages.add(subscribedPackage);
            }
          }
        }

        yield state.copyWith(gitHubStarredPackages: gitHubStarredPackages);
      }
      event.completer.complete();
    }
  }

  @override
  SubscriptionState fromJson(Map<String, dynamic> json) =>
      SubscriptionState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SubscriptionState state) => state.toJson();

  bool hasSubscriptionFor(String packageName) =>
      state.subscribedPackages
          .indexWhere((package) => package.name == packageName) !=
      -1;

  Future<FullPackage> getSubscriptionAsFullPackage(
          FullPackage subscription) async =>
      _packageRepository.get(subscription.name);

  // ignore: missing_return
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  // ignore: missing_return
  Future onSelectNotification(String payload) {}
}

Future<List<FullPackage>> checkForUpdates(
    List<FullPackage> subscribedPackages) async {
  List<FullPackage> updatedPackages = [];
  debugPrint('[Background Fetch] Running background fetch.');
  final _client = PubHtmlParsingClient();
  for (final subscribedPackage in subscribedPackages) {
    FullPackage package = await _client.get(subscribedPackage.name);
    if (package.latestSemanticVersion >
        subscribedPackage.latestSemanticVersion) {
      debugPrint(
          '[Background Fetch] Updated package found for "${subscribedPackage.name}"');
      updatedPackages.add(package);
    } else {
      debugPrint(
          '[Background Fetch] No update found for "${subscribedPackage.name}"');
    }
  }
  return updatedPackages;
}
