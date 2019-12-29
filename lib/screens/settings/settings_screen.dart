import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:github/github.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/settings/settings_event.dart';
import 'package:simple_auth/simple_auth.dart';
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:tavern/secrets.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsState state;

  const SettingsScreen({Key key, @required this.state}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool enableGithub = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  TextEditingController _usernameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    SimpleAuthFlutter.init(context);
    _initPackageInfo();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    bool themeIsLight = DynamicTheme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Settings',
          style: TextStyle(
            color: themeIsLight ? Colors.black : Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeIsLight ? Colors.black : Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Set Theme to ${themeIsLight ? 'Dark' : 'Light'}',
            ),
            trailing:
                Icon(themeIsLight ? Icons.brightness_3 : Icons.brightness_6),
            onTap: () {
              final SettingsBloc settingsBloc =
                  BlocProvider.of<SettingsBloc>(context);
              settingsBloc.add(ToggleThemeEvent(context: context));
            },
          ),
          ListTile(
            title: DropdownButton<SortType>(
              items: [
                DropdownMenuItem(
                  child: Text('Overall Score (default)'),
                  value: SortType.overAllScore,
                ),
                DropdownMenuItem(
                  child: Text('Recently Updated'),
                  value: SortType.recentlyUpdated,
                ),
                DropdownMenuItem(
                  child: Text('Newest Package'),
                  value: SortType.newestPackage,
                ),
                DropdownMenuItem(
                  child: Text('Popularity'),
                  value: SortType.popularity,
                ),
                DropdownMenuItem(
                  child: Text('Search Relevance'),
                  value: SortType.searchRelevance,
                ),
              ],
              onChanged: (sortType) {
                settingsBloc.add(SetSortTypeEvent(sortType: sortType));
              },
              value: state.sortBy,
              hint: Text('Default Feed Sort'),
              isExpanded: true,
            ),
          ),
          ListTile(
            title: DropdownButton<FilterType>(
              items: [
                DropdownMenuItem(
                  child: Text('All (default)'),
                  value: FilterType.all,
                ),
                DropdownMenuItem(
                  child: Text('Flutter'),
                  value: FilterType.flutter,
                ),
                DropdownMenuItem(
                  child: Text('Web'),
                  value: FilterType.web,
                ),
              ],
              onChanged: (filterType) => settingsBloc.add(SetFilterTypeEvent(
                filterType: filterType,
              )),
              value: state.filterBy,
              hint: Text('Default Feed Filter'),
              isExpanded: true,
            ),
          ),
          ListTile(
            title: Text('Clear Caches'),
            onTap: () {
              getIt.get<FullPackageCache>()?.clear();
              getIt.get<SearchCache>()?.clear();
              getIt.get<PageCache>()?.clear();
              debugPrint('Caches cleared');
            },
          ),
          if (enableGithub)
            ExpansionTile(
              title: Text("Sign In to GitHub"),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration:
                        InputDecoration(labelText: "Username", isDense: true),
                  ),
                ),
                if (enableGithub)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        isDense: true,
                      ),
                      obscureText: true,
                    ),
                  ),
                if (enableGithub)
                  ProgressButton(
                    animate: true,
                    type: ProgressButtonType.Flat,
                    defaultWidget:
                        Text(state.isAuthenticated ? 'Sign Out' : 'Sign In'),
                    progressWidget: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    onPressed: () async {
                      var flow = OAuth2Flow(gitHubClientId, gitHubClientSecret);
                      var authUrl = flow.createAuthorizeUrl();
                      // Display to the User and handle the redirect URI, and also get the code.
//                  flow.exchange(code).then((response) {
//                    var github = new GitHub(
//                        auth: new Authentication.withToken(response.token));
//                    // Use the GitHub Client
//                  });
//                  final githubApi = GithubApi(
//                    "github",
//                    gitHubClientId,
//                    gitHubClientSecret,
//                    "com.thinkdigital.software",
//                    scopes: [
//                      "repo",
//                      "public_repo",
//                    ],
//                  );
//                  login(githubApi);
                      launch(
                        '$authUrl&redirect_uri=http://127.0.0.1:8080/redirect ',
                      );
                      HttpServer server = await HttpServer.bind(
                          InternetAddress.loopbackIPv4, 8080);
                      server.listen((HttpRequest request) async {
                        request.response
                          ..statusCode = 200
                          ..headers
                              .set("Content-Type", ContentType.html.mimeType)
                          ..write(
                              "<html><h1>You can now close this window</h1></html>");
                        await request.response.close();
                        await server.close(force: true);
                      });
                      settingsBloc.add(
                        AuthenticateWithGithub(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                  )
              ],
            ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListTile(
              title: Text('Version ${_packageInfo.version}'),
              subtitle:
                  Text('Authored by ThinkDigitalSoftware and GroovinChip'),
            ),
          )
        ],
      ),
    );
  }

  SettingsState get state => widget.state;
}

void login(AuthenticatedApi api) async {
  try {
    final success = await api.authenticate();
    print(success);
    final github = GitHub(
      auth: Authentication.withToken(''),
    );
    await for (final gist in github.gists.listCurrentUserGists()) {
      print(gist.htmlUrl);
    }
  } catch (e) {
    print(e);
  }
}
