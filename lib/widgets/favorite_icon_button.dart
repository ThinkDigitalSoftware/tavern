part of 'widgets.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    Key key,
    @required FullPackage package,
  })  : _package = package,
        super(key: key);

  final FullPackage _package;

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc _subscriptionBloc =
        BlocProvider.of<SubscriptionBloc>(context);
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        bool isFavorited = _subscriptionBloc.hasSubscriptionFor(_package.name);
        return IconButton(
          tooltip: "Favorite",
          icon: FavoriteIcon(isFavorited: isFavorited),
          onPressed: () {
            if (isFavorited) {
              _subscriptionBloc.add(RemoveSubscriptionForFullPackage(_package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  unsubscribedSnackBar(
                    subscription: Subscription.fromFullPackage(_package),
                    subscriptionBloc: _subscriptionBloc,
                  ),
                );
            } else {
              _subscriptionBloc.add(AddSubscriptionFromFullPackage(_package));
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  subscribedSnackBar(
                    subscription: Subscription.fromFullPackage(_package),
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
  }) : super(key: key);

  final bool isFavorited;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorited ? Icons.star : Icons.star_border,
      color: DynamicTheme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryIconTheme.color
          : Colors.white,
    );
  }
}
