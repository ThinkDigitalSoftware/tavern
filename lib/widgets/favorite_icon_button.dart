import 'package:dynamic_theme/dynamic_theme.dart';
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
    final _subscriptionBloc = BlocProvider.of<SubscriptionBloc>(context);
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        final isFavorited = _subscriptionBloc.hasSubscriptionFor(package.name);
        return IconButton(
          color: color,
          tooltip: "Favorite",
          icon: FavoriteIcon(isFavorited: isFavorited),
          onPressed: () {
            if (isFavorited) {
              _subscriptionBloc.add(RemoveSubscription(package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  unsubscribedSnackBar(
                    subscription: package,
                    subscriptionBloc: _subscriptionBloc,
                  ),
                );
            } else {
              _subscriptionBloc.add(AddSubscription(package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  subscribedSnackBar(
                    subscription: package,
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
  @required FullPackage subscription,
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
  @required FullPackage subscription,
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
      color: color ??
          (DynamicTheme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryIconTheme.color
              : Colors.white),
    );
  }
}
