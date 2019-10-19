import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class SubscriptionEvent {}

class AddSubscription extends SubscriptionEvent {
  final FullPackage subscription;

  AddSubscription(this.subscription);
}

class RemoveSubscription extends SubscriptionEvent {
  final FullPackage subscription;

  RemoveSubscription(this.subscription);
}

class GetGitHubStars extends SubscriptionEvent {
  final BuildContext context;
  final Completer completer = Completer();

  GetGitHubStars({@required this.context});
}
