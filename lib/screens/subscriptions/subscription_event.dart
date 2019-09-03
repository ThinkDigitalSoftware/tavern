import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/subscriptions/subscription_state.dart';

@immutable
abstract class SubscriptionEvent {}

class AddSubscriptionFromFullPackage extends SubscriptionEvent {
  final FullPackage package;

  AddSubscriptionFromFullPackage(this.package);
}

class AddSubscription extends SubscriptionEvent {
  final Subscription subscription;

  AddSubscription(this.subscription);
}

class RemoveSubscriptionForFullPackage extends SubscriptionEvent {
  final FullPackage package;

  RemoveSubscriptionForFullPackage(this.package);
}

class RemoveSubscription extends SubscriptionEvent {
  final Subscription subscription;

  RemoveSubscription(this.subscription);
}
