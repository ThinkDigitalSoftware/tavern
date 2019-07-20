import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/home/home.dart';
import 'package:tavern/screens/package_details/package_details_page.dart';
import 'package:tavern/screens/search_screen.dart';
import 'package:tavern/screens/settings/settings_screen.dart';
import 'package:tavern/src/pub_colors.dart';

void main() {
  runApp(PubDevClientApp());
}

class PubDevClientApp extends StatefulWidget {
  @override
  _PubDevClientAppState createState() => _PubDevClientAppState();
}

class _PubDevClientAppState extends State<PubDevClientApp> {
  PubHtmlParsingClient _htmlParsingClient;
  SettingsBloc _settingsBloc;
  HomeBloc _homeBloc;
  PackageDetailsBloc _packageDetailsBloc;

  @override
  void initState() {
    _htmlParsingClient = PubHtmlParsingClient();
    _settingsBloc = SettingsBloc();
    _homeBloc = HomeBloc(client: _htmlParsingClient);
    _packageDetailsBloc = PackageDetailsBloc(client: _htmlParsingClient);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
          ThemeData(
            fontFamily: 'Metropolis',
            accentColor: Color(0xFF38bffc),
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              builder: (BuildContext context) => _homeBloc,
            ),
            BlocProvider<SettingsBloc>(
              builder: (BuildContext context) => _settingsBloc,
            ),
            BlocProvider<PackageDetailsBloc>(
              builder: (BuildContext context) => _packageDetailsBloc,
            ),
          ],
          child: Provider<PubColors>(
            builder: (context) => PubColors(),
            child: MaterialApp(
              theme: theme,
              title: "Tavern",
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                "/": (BuildContext context) =>
                    BlocBuilder<HomeEvent, HomeState>(
                        bloc: _homeBloc,
                        builder: (context, state) {
                          return Home(homeState: state);
                        }),
                "/searchScreen": (BuildContext context) => SearchScreen(),
                "/settingsScreen": (BuildContext context) =>
                    BlocBuilder<SettingsEvent, SettingsState>(
                        bloc: _settingsBloc,
                        builder: (context, state) {
                          return SettingsScreen(
                            settingsState: state,
                          );
                        }),
                PackageDetailsPage.routeName: (context) =>
                    BlocBuilder<PackageDetailsEvent, PackageDetailsState>(
                      bloc: _packageDetailsBloc,
                      builder:
                          (BuildContext context, PackageDetailsState state) =>
                          PackageDetailsPage(
                            packageDetailsState: state,
                          ),
                    ),
              },
            ),
          ),
        );
      },
    );
  }
}
