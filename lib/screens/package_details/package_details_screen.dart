import 'dart:io';

import 'package:dynamic_overflow_menu_bar/dynamic_overflow_menu_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/tabs.dart';
import 'package:tavern/src/pub_colors.dart';
import 'package:tavern/widgets/favorite_icon_button.dart';
import 'package:tavern/widgets/score_tab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class PackageDetailsScreen extends StatefulWidget {
  const PackageDetailsScreen({Key key}) : super(key: key);

  @override
  _PackageDetailsScreenState createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;
  ScrollController _scrollViewController;
  Color scoreColor;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageDetailsBloc, PackageDetailsState>(
        builder: (context, packageDetailsState) {
      FullPackage _package = packageDetailsState.package;

      SubscriptionBloc _subscriptionBloc =
          BlocProvider.of<SubscriptionBloc>(context);
      Widget scaffoldBody;
      bool showAppBar = true;

      if (packageDetailsState is InitialPackageDetailsState) {
        scaffoldBody = Center(
          child: CircularProgressIndicator(),
        );
      } else if (packageDetailsState is PackageDetailsErrorState) {
        scaffoldBody = Center(
          child: Text(
            packageDetailsState.error.toString(),
            textAlign: TextAlign.center,
          ),
        );
      } else if (_package is DartLibraryFullPackage) {
        scaffoldBody = Center(
          child: Card(
            child: Text("Dart Library Packages are not yet supported"),
          ),
        );
      } else {
        showAppBar = false;
        scoreColor = _getScoreColor(context, _package.score);
        _tabs = [
          Tab(
            child: Text('Readme'),
          ),
          Tab(
            child: Text('Changelog'),
          ),
          Tab(
            child: Text('Example'),
          ),
          Tab(
            child: Text('Installing'),
          ),
          Tab(
            child: Text('Versions'),
          ),
          Tab(
            child: CircleAvatar(
              backgroundColor: scoreColor,
              child: Text(
                packageDetailsState.package.score.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Tab(
            child: Text('About'),
          ),
        ];
        scaffoldBody = NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (context, innerBoxScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
                pinned: true,
                floating: true,
                title: DynamicOverflowMenuBar(
                  title: FittedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _package.name,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: Theme.of(context).primaryTextTheme.title,
                          ),
                          Text(
                            _package.latestSemanticVersion.toString(),
                            style: Theme.of(context).primaryTextTheme.subtitle,
                          )
                        ],
                      ),
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                  actions: <OverFlowMenuItem>[
                    OverFlowMenuItem(
                      label: "API Reference",
                      child: IconButton(
                        tooltip: "API Reference",
                        icon: FittedBox(
                          child: CircleAvatar(
                            radius: 37,
                            backgroundColor:
                                Theme.of(context).primaryTextTheme.body1.color,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Theme.of(context).cardColor,
                              child: Text(
                                'API',
                                style: TextStyle(
                                  color: isLightTheme(context)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => launch(_package.apiReferenceUrl),
                      ),
                      onPressed: () => launch(_package.apiReferenceUrl),
                    ),
                    if (_package.repositoryUrl != null)
                      OverFlowMenuItem(
                        label: "Repo",
                        child: IconButton(
                          tooltip: "Repo",
                          icon: Icon(Icons.code),
                          onPressed: () => launch(_package.repositoryUrl),
                        ),
                        onPressed: () => launch(_package.repositoryUrl),
                      ),
                    if (_package.issuesUrl != null)
                      OverFlowMenuItem(
                        label: 'Issues',
                        child: IconButton(
                          tooltip: "Issues",
                          icon: Icon(
                            Icons.bug_report,
                          ),
                          onPressed: () => launch(_package.issuesUrl),
                        ),
                        onPressed: () => launch(_package.issuesUrl),
                      ),
                    OverFlowMenuItem(
                      label: 'Favorite',
                      child: FavoriteIconButton(package: _package),
                      onPressed: () {
                        if (_subscriptionBloc
                            .hasSubscriptionFor(_package.name)) {
                          _subscriptionBloc
                              .add(RemoveSubscriptionForFullPackage(_package));
                          Scaffold.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                    "You have unsubscribed from ${_package.name}"),
                                action: SnackBarAction(
                                  onPressed: () => _subscriptionBloc.add(
                                      AddSubscriptionFromFullPackage(_package)),
                                  label: "Undo",
                                ),
                              ),
                            );
                        } else {
                          _subscriptionBloc
                              .add(AddSubscriptionFromFullPackage(_package));
                          Scaffold.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                    "You have subscribed to ${_package.name}"),
                                action: SnackBarAction(
                                  onPressed: () => _subscriptionBloc.add(
                                    RemoveSubscriptionForFullPackage(
                                      _package,
                                    ),
                                  ),
                                  label: "Undo",
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    OverFlowMenuItem(
                      child: IconButton(
                        icon: Icon(GroovinMaterialIcons.web),
                        onPressed: () => launch(_package.url),
                      ),
                      onPressed: () => launch(_package.url),
                      label: "Show in browser",
                    ),
                    OverFlowMenuItem(
                      label: 'Share',
                      child: IconButton(
                        icon: Icon(_buildShareIcon()),
                        onPressed: () => Share.share(_package.url,
                            subject: "Check out this package on pub.dev!"),
                      ),
                      onPressed: () => Share.share(_package.url,
                          subject: "Check out this package on pub.dev!"),
                    )
                  ],
                ),
                bottom: TabBar(
                  tabs: _tabs,
                  controller: _tabController,
                  isScrollable: true,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ReadmeTab(packageTab: _package.packageTabs['ReadMePackageTab']),
              ChangelogTab(
                packageTab: _package.packageTabs['ChangelogPackageTab'],
              ),
              ExampleTab(
                packageTab: _package.packageTabs['ExamplePackageTab'],
              ),
              InstallingTab(
                packageTab: _package.packageTabs['InstallingPackageTab'],
              ),
              VersionsTab(
                versions: _package.versions,
              ),
              AnalysisTab(
                packageTab: _package.packageTabs['AnalysisPackageTab'],
              ),
              AboutTab(
                package: _package,
              ),
            ],
          ),
        );
      }
      return Scaffold(
        appBar: showAppBar
            ? AppBar(
                centerTitle: false,
                backgroundColor:
                    DynamicTheme.of(context).data.appBarTheme.color,
                title: Text(packageDetailsState.package.name),
              )
            : null,
        body: scaffoldBody,
      );
    });
  }

  bool isLightTheme(BuildContext context) =>
      DynamicTheme.of(context).brightness == Brightness.light;

  IconData _buildShareIcon() {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoIcons.share;
    }
    return Icons.share;
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score == null) {
      return null;
    }
    if (score <= 50) {
      return PubColors.badPackageScore;
    } else if (score >= 51 && score <= 69) {
      return PubColors.goodPackageScore;
    } else {
      return PubColors.greatPackageScore;
    }
  }
}

class PackageDetailsArguments {
  final String packageName;

  PackageDetailsArguments(this.packageName);
}
