import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({this.package, this.color});

  final FullPackage package;
  final Color color;

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc _subscriptionBloc =
        BlocProvider.of<SubscriptionBloc>(context);
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        bool isFavorited = _subscriptionBloc.hasSubscriptionFor(package.name);
        return IconButton(
          color: color,
          tooltip: "Favorite",
          icon: FavoriteIcon(isFavorited: isFavorited),
          onPressed: () {
            if (isFavorited) {
              _subscriptionBloc.add(RemoveSubscriptionForFullPackage(package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  unsubscribedSnackBar(
                    subscription: Subscription.fromFullPackage(package),
                    subscriptionBloc: _subscriptionBloc,
                  ),
                );
            } else {
              _subscriptionBloc.add(AddSubscriptionFromFullPackage(package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  subscribedSnackBar(
                    subscription: Subscription.fromFullPackage(package),
                    subscriptionBloc: _subscriptionBloc,
                  ),
                );
            }
          },
        );
      },
    );
  }
}

SnackBar subscribedSnackBar({
  @required Subscription subscription,
  @required SubscriptionBloc subscriptionBloc,
}) {
  return SnackBar(
    content: Text("You have subscribed to ${subscription.name}"),
    action: SnackBarAction(
      onPressed: () => subscriptionBloc.add(RemoveSubscription(subscription)),
      label: "Undo",
    ),
    behavior: SnackBarBehavior.floating,
  );
}

SnackBar unsubscribedSnackBar({
  @required Subscription subscription,
  @required SubscriptionBloc subscriptionBloc,
}) {
  return SnackBar(
    content: Text("You have unsubscribed from ${subscription.name}"),
    action: SnackBarAction(
      onPressed: () => subscriptionBloc.add(AddSubscription(subscription)),
      label: "Undo",
    ),
    behavior: SnackBarBehavior.floating,
  );
}

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key key,
    @required this.isFavorited,
    this.color,
  }) : super(key: key);

  final bool isFavorited;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorited ? Icons.star : Icons.star_border,
      color: color,
    );
  }
}
