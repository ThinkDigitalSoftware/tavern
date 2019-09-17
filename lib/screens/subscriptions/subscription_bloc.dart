import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';

import '../bloc.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  final PubHtmlParsingClient client;
  final FullPackageRepository _packageRepository =
      GetIt.instance.get<FullPackageRepository>();

  @override
  SubscriptionState get initialState =>
      super.initialState ?? InitialSubscriptionState();

  SubscriptionBloc({@required this.client}) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
        onDidReceiveLocalNotification); // TODO: implement
    var initializationSettings = InitializationSettings(
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
      checkForUpdates(currentState.subscribedPackages).then((updatedPackages) {
        debugPrint(
            'Notifying user of updates to ${updatedPackages.length} packages.');
      });
    });
  }

  @override
  Stream<SubscriptionState> mapEventToState(
    SubscriptionEvent event,
  ) async* {
    if (event is AddSubscriptionFromFullPackage) {
      yield currentState.withPackage(event.package);
    } else if (event is AddSubscription) {
      yield currentState.withSubscription(event.subscription);
    } else if (event is RemoveSubscriptionForFullPackage) {
      yield currentState.withoutPackage(event.package);
    } else if (event is RemoveSubscription) {
      yield currentState.withoutSubscription(event.subscription);
    }
  }

  @override
  SubscriptionState fromJson(Map<String, dynamic> json) =>
      SubscriptionState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SubscriptionState state) => state.toJson();

  bool hasSubscriptionFor(String packageName) =>
      currentState.subscribedPackages
          .indexWhere((package) => package.name == packageName) !=
      -1;

  Future<FullPackage> getSubscriptionAsFullPackage(
          Subscription subscription) async =>
      _packageRepository.get(subscription.name);

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) {}

  Future onSelectNotification(String payload) {}
}

Future<List<FullPackage>> checkForUpdates(
    List<Subscription> subscribedPackages) async {
  List<FullPackage> updatedPackages = [];
  debugPrint('[Background Fetch] Running background fetch.');
  final _client = PubHtmlParsingClient();
  for (final subscribedPackage in subscribedPackages) {
    FullPackage package = await _client.get(subscribedPackage.name);
    if (package.latestSemanticVersion >
        subscribedPackage.latestSemanticVersion) {
      debugPrint(
          '[Background Fetch] Updated package found for "${subscribedPackage
              .name}"');
      updatedPackages.add(package);
    } else {
      debugPrint(
          '[Background Fetch] No update found for "${subscribedPackage.name}"');
    }
  }
  return updatedPackages;
}
