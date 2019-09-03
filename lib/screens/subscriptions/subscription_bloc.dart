import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';

import '../bloc.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  final PubHtmlParsingClient client;
  final PackageRepository _packageRepository =
      GetIt.instance.get<PackageRepository>();

  @override
  SubscriptionState get initialState =>
      super.initialState ?? InitialSubscriptionState();

  SubscriptionBloc({@required this.client});

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
}
