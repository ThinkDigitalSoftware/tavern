import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';

import './bloc.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  final PubHtmlParsingClient client;

  @override
  SubscriptionState get initialState =>
      super.initialState ?? InitialSubscriptionState();

  SubscriptionBloc({@required this.client});

  @override
  Stream<SubscriptionState> mapEventToState(
    SubscriptionEvent event,
  ) async* {
    if (event is AddSubscription) {
      yield currentState.add(event.package);
    } else if (event is RemoveSubscription) {
      yield currentState.remove(event.package);
    }
  }

  @override
  SubscriptionState fromJson(Map<String, dynamic> json) =>
      SubscriptionState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SubscriptionState state) => state.toJson();
}
