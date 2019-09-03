import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class SubscriptionState {
  final List<Subscription> subscribedPackages;

  const SubscriptionState({@required this.subscribedPackages});

  SubscriptionState withPackage(FullPackage package) => SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)
          ..add(
            Subscription.fromFullPackage(package),
          ),
      );

  SubscriptionState withSubscription(Subscription subscription) =>
      SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)..add(subscription),
      );

  SubscriptionState withoutPackage(FullPackage package) {
    assert(subscribedPackages.contains(package));
    return SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)
          ..remove(Subscription.fromFullPackage(package)));
  }

  SubscriptionState withoutSubscription(Subscription subscription) {
    assert(subscribedPackages.contains(subscription));
    return SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)
          ..remove(subscription));
  }

  Map<String, dynamic> toJson() {
    List<Map> jsonList = [];
    for (final subscription in subscribedPackages) {
      jsonList.add(subscription.toJson());
    }

    return {"subscribedPackages": jsonList};
  }

  factory SubscriptionState.fromJson(Map<String, dynamic> json) {
    return SubscriptionState(
      subscribedPackages: List.of(json["subscribedPackages"])
          .map((package) => Subscription.fromJson(package))
          .toList(),
    );
  }
}

class InitialSubscriptionState extends SubscriptionState {
  const InitialSubscriptionState() : super(subscribedPackages: const []);
}

class Subscription {
  final String name;
  final String url;

  Subscription({@required this.name, @required this.url});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      name: json["name"],
      url: json["url"],
    );
  }

  factory Subscription.fromFullPackage(FullPackage package) =>
      Subscription(name: package.name, url: package.url);

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          url == other.url ||
      other is FullPackage && Subscription.fromFullPackage(other) == this;

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
