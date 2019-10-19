import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class SubscriptionState {
  final List<FullPackage> subscribedPackages;
  final List<FullPackage> gitHubStarredPackages;

  const SubscriptionState(
      {@required this.subscribedPackages, this.gitHubStarredPackages});

  SubscriptionState withSubscription(FullPackage package) => SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)
          ..add(
            package,
          ),
      );

  SubscriptionState withoutSubscription(FullPackage package) {
    assert(subscribedPackages.contains(package));
    return SubscriptionState(
        subscribedPackages: List.from(subscribedPackages)..remove(package));
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
          .map((package) => FullPackage.fromJson(package))
          .toList(),
    );
  }

  SubscriptionState copyWith({
    List<FullPackage> subscribedPackages,
    List<FullPackage> gitHubStarredPackages,
  }) {
    return SubscriptionState(
      subscribedPackages: subscribedPackages ?? this.subscribedPackages,
      gitHubStarredPackages:
          gitHubStarredPackages ?? this.gitHubStarredPackages,
    );
  }
}

class InitialSubscriptionState extends SubscriptionState {
  const InitialSubscriptionState() : super(subscribedPackages: const []);
}
