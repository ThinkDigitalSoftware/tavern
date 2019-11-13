import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/widgets/favorite_icon_button.dart';

class SubscriptionsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc subscriptionBloc =
        BlocProvider.of<SubscriptionBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text("Favorites"),
        centerTitle: false,
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (BuildContext context, SubscriptionState state) {
          return ListView.builder(
            itemCount: state.subscribedPackages.length,
            itemBuilder: (BuildContext context, int index) {
              Subscription subscription = state.subscribedPackages[index];
              return FavoritesTile(
                subscription: subscription,
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                    unsubscribedSnackBar(
                      subscription: subscription,
                      subscriptionBloc: subscriptionBloc,
                    ),
                  );
                  subscriptionBloc.add(RemoveSubscription(subscription));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FavoritesTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onPressed;

  const FavoritesTile(
      {Key key, @required this.subscription, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subscription.name),
      subtitle: Text(subscription.url),
      contentPadding: EdgeInsets.all(15),
      trailing: IconButton(
        tooltip: "Unsubscribe",
        icon: FavoriteIcon(
          isFavorited: true,
        ),
        onPressed: onPressed,
      ),
      onTap: () async {
        final getPackageDetailsEvent = GetPackageDetailsEvent(
          packageName: subscription.name,
        );
        BlocProvider.of<PackageDetailsBloc>(context)
            .add(getPackageDetailsEvent);
        return Navigator.pushNamed(
          context,
          Routes.packageDetailsScreen,
          arguments: PackageDetailsArguments(
            subscription.name,
          ),
        );
      },
    );
  }
}
