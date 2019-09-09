import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_overflow_menu_bar/dynamic_overflow_menu_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/src/pub_colors.dart';
import 'package:tavern/widgets/favorite_icon_button.dart';
import 'package:tavern/widgets/html_view.dart';
import 'package:tavern/widgets/score_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailsScreen extends StatefulWidget {
  final PackageDetailsState packageDetailsState;

  const PackageDetailsScreen({Key key, @required this.packageDetailsState})
      : super(key: key);

  @override
  _PackageDetailsScreenState createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;
  ScrollController _scrollViewController;
  Color scoreColor;
  PackageDetailsBloc packageDetailsBloc;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    _scrollViewController = ScrollController();
    BackButtonInterceptor.add(interceptBackButton);

    super.initState();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    BackButtonInterceptor.remove(interceptBackButton);

    packageDetailsBloc.dispatch(InitializePackageDetailsBloc());
    super.dispose();
  }

  bool interceptBackButton(stopDefaultButtonEvent) {
    Navigator.pop(context);
    return true;
  }

  FullPackage get _package => widget.packageDetailsState.package;

  PackageDetailsState get packageDetailsState => widget.packageDetailsState;

  @override
  Widget build(BuildContext context) {
    //added so the bloc can be reset when disposed.
    packageDetailsBloc ??= BlocProvider.of<PackageDetailsBloc>(context);
    SubscriptionBloc _subscriptionBloc =
        BlocProvider.of<SubscriptionBloc>(context);
    if (packageDetailsState is InitialPackageDetailsState) {
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _getScoreColor(context);
    _tabs = [
      Tab(
        child: Text(
          'Readme',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Changelog',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Example',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Installing',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Versions',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
      Tab(
        child: CircleAvatar(
          backgroundColor: scoreColor,
          child: Text(
            widget.packageDetailsState.package.score.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      Tab(
        child: Text(
          'About',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    ];
    return Scaffold(
        body: NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (context, innerBoxScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            pinned: true,
            floating: true,
            title: Row(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _package.name,
                        style: Theme
                            .of(context)
                            .primaryTextTheme
                            .title,
                      ),
                      Text(
                        _package.latestSemanticVersion.toString(),
                        style: Theme
                            .of(context)
                            .primaryTextTheme
                            .subtitle,
                      )
                    ],
                  ),
                  physics: NeverScrollableScrollPhysics(),
                ),
                Expanded(
                  child: DynamicOverflowMenuBar(
                    actions: <OverFlowMenuItem>[
                      OverFlowMenuItem(
                        label: "API Reference",
                        child: IconButton(
                          tooltip: "API Reference",
                          icon: FittedBox(
                            child: CircleAvatar(
                              radius: 37,
                              backgroundColor: Theme.of(context)
                                  .primaryTextTheme
                                  .body1
                                  .color,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Theme.of(context).cardColor,
                                child: Text(
                                  'API',
                                  style: TextStyle(
                                    color:
                                        DynamicTheme.of(context).brightness ==
                                                Brightness.light
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
                            icon: Icon(
                              Icons.code,
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
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
                              color: DynamicTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
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
                            _subscriptionBloc.dispatch(
                                RemoveSubscriptionForFullPackage(_package));
                            Scaffold.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "You have unsubscribed from ${_package.name}"),
                                  action: SnackBarAction(
                                    onPressed: () => _subscriptionBloc.dispatch(
                                        AddSubscriptionFromFullPackage(
                                            _package)),
                                    label: "Undo",
                                  ),
                                ),
                              );
                          } else {
                            _subscriptionBloc.dispatch(
                                AddSubscriptionFromFullPackage(_package));
                            Scaffold.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "You have subscribed to ${_package.name}"),
                                  action: SnackBarAction(
                                    onPressed: () => _subscriptionBloc.dispatch(
                                        RemoveSubscriptionForFullPackage(
                                            _package)),
                                    label: "Undo",
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
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
          ScoreTab(
            package: _package,
          ),
          AboutTab(
            package: _package,
          ),
        ],
      ),
    ));
  }

  void _getScoreColor(BuildContext context) {
    int score = _package.score;
    if (score <= 50 || score == null) {
      scoreColor = Provider.of<PubColors>(context).badPackageScore;
    } else if (score >= 51 && score <= 69) {
      scoreColor = Provider.of<PubColors>(context).goodPackageScore;
    } else {
      scoreColor = Provider.of<PubColors>(context).greatPackageScore;
    }
  }
}

class PackageDetailsArguments {
  final String packageName;
  final String packageScore;

  PackageDetailsArguments(this.packageName, this.packageScore);
}

class VersionsTab extends StatelessWidget {
  final List<Version> versions;

  const VersionsTab({Key key, this.versions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (versions == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return ListView.builder(
      itemCount: versions.length,
      itemBuilder: (context, index) {
        //TODO: Build a table with Version, Uploaded Date, Documentation URL, and Archive columns
        return ListTile(
          title: Text('${versions[index].semanticVersion.major}'
              '.${versions[index].semanticVersion.minor}'
              '.${versions[index].semanticVersion.patch}'),
        );
      },
    );
  }
}

class InstallingTab extends StatelessWidget {
  final InstallingPackageTab packageTab;

  const InstallingTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(html: packageTab.content),
        ),
      ],
    );
  }
}

class ExampleTab extends StatelessWidget {
  final ExamplePackageTab packageTab;

  const ExampleTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(html: packageTab.content),
        ),
      ],
    );
  }
}

class ChangelogTab extends StatelessWidget {
  final ChangelogPackageTab packageTab;

  const ChangelogTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(
            html: packageTab.content,
          ),
        ),
      ],
    );
  }
}

class ReadmeTab extends StatelessWidget {
  final ReadMePackageTab packageTab;

  const ReadmeTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packageTab == null) {
      return Center(
        child: Text('No content'),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(html: packageTab.content),
        ),
      ],
    );
  }
}

class AboutTab extends StatelessWidget {
  final FullPackage package;

  const AboutTab({Key key, this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: ListView(
        children: <Widget>[
          Text(package.description),
          Text('Author: ${package.author}'),
          Text('Uploaders:'),
          for (String uploader in package.uploaders)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(uploader),
                FlatButton.icon(
                  icon: Icon(Icons.mail_outline),
                  label: Text('Email'),
                  onPressed: () => launch('mailto:$uploader'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ErrorReport extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const ErrorReport({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            snapshot.error.toString(),
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'This error was unexpected. Please file an issue on our GitHub repository so we can fix it.'),
        ),
        RaisedButton.icon(
          icon: Icon(GroovinMaterialIcons.github_circle),
          label: Text('File Issue'),
          onPressed: () {
            //TODO: launch new issue page for our repo, pass in error if possible
          },
        ),
      ],
    );
  }
}
