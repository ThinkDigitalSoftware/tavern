import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class SubscriptionState {
  final List<FullPackage> subscribedPackages;

  const SubscriptionState({@required this.subscribedPackages});

  SubscriptionState add(FullPackage package) => SubscriptionState(
      subscribedPackages: List.from(subscribedPackages)..add(package));

  SubscriptionState remove(FullPackage package) => SubscriptionState(
      subscribedPackages: List.from(subscribedPackages)..remove(package));

  Map<String, dynamic> toJson() {
    return {"subscribedPackages": jsonEncode(subscribedPackages)};
  }

  factory SubscriptionState.fromJson(Map<String, dynamic> json) {
    return SubscriptionState(
      subscribedPackages: List.of(json["subscribedPackages"])
          .map((package) => FullPackage.fromJson(package))
          .toList(),
    );
  }
}

class InitialSubscriptionState extends SubscriptionState {
  const InitialSubscriptionState() : super(subscribedPackages: const []);
}
