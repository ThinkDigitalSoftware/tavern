import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class SubscriptionEvent {}

class AddSubscription extends SubscriptionEvent {
  final FullPackage package;

  AddSubscription(this.package);
}

class RemoveSubscription extends SubscriptionEvent {
  final FullPackage package;

  RemoveSubscription(this.package);
}
