import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/widgets/favorite_icon_button.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SubscriptionBloc subscriptionBloc;

  @override
  void initState() {
    super.initState();
    subscriptionBloc ??= BlocProvider.of<SubscriptionBloc>(context);

    subscriptionBloc.state.gitHubStarredPackages ??
        subscriptionBloc.add(GetGitHubStars(context: context));
  }

  @override
  Widget build(BuildContext context) {
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
          return RefreshIndicator(
            child: ListView.builder(
              itemCount: state.subscribedPackages.length,
              itemBuilder: (BuildContext context, int index) {
                FullPackage subscription = state.subscribedPackages[index];
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
                  isGitHubStarred:
                      state.gitHubStarredPackages?.contains(subscription) ??
                          false,
                );
              },
            ),
            onRefresh: () async {
              final getGitHubStars = GetGitHubStars(context: context);
              subscriptionBloc.add(getGitHubStars);
              return getGitHubStars.completer.future;
            },
          );
        },
      ),
    );
  }
}

class FavoritesTile extends StatelessWidget {
  final FullPackage subscription;
  final VoidCallback onPressed;
  final bool isGitHubStarred;

  const FavoritesTile({
    Key key,
    @required this.subscription,
    @required this.onPressed,
    @required this.isGitHubStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subscription.name),
      subtitle: Text(subscription.url),
      contentPadding: EdgeInsets.all(15),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isGitHubStarred)
            IconButton(
              tooltip: "Starred on GitHub",
              icon: FavoriteIcon(
                isFavorited: true,
              ),
              onPressed: onPressed,
            ),
          IconButton(
            tooltip: "Unsubscribe",
            icon: FavoriteIcon(
              isFavorited: true,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
      onTap: () async => Navigator.pushNamed(
        context,
        Routes.packageDetailsScreen,
        arguments: PackageDetailsArguments(
          subscription.name,
        ),
      ),
    );
  }
}
