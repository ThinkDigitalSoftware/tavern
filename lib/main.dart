import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/home/home.dart';
import 'package:tavern/screens/package_details/package_details_bloc.dart';
import 'package:tavern/screens/package_details/package_details_page.dart';
import 'package:tavern/screens/search_screen.dart';
import 'package:tavern/screens/settings/settings_screen.dart';
import 'package:tavern/src/pub_colors.dart';

Future main() async {
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  PubHtmlParsingClient _htmlParsingClient;

  _htmlParsingClient = PubHtmlParsingClient();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>(
        builder: (BuildContext context) => HomeBloc(client: _htmlParsingClient),
      ),
      BlocProvider<SettingsBloc>(
        builder: (BuildContext context) => SettingsBloc(),
      ),
      BlocProvider<PackageDetailsBloc>(
        builder: (BuildContext context) =>
            PackageDetailsBloc(client: _htmlParsingClient),
      ),
    ],
    child: PubDevClientApp(),
  ));
}

class PubDevClientApp extends StatefulWidget {
  @override
  _PubDevClientAppState createState() => _PubDevClientAppState();
}

class _PubDevClientAppState extends State<PubDevClientApp> {
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
        return Provider<PubColors>(
          builder: (context) => PubColors(),
          child: MaterialApp(
            theme: theme,
            title: "Tavern",
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              "/": (BuildContext context) =>
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (BuildContext context, HomeState state) =>
                        Home(homeState: state),
                  ),
              "/searchScreen": (BuildContext context) => SearchScreen(),
              "/settingsScreen": (BuildContext context) =>
                  BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return SettingsScreen(
                          settingsState: state,
                        );
                      }),
              PackageDetailsPage.routeName: (context) =>
                  BlocBuilder<PackageDetailsBloc, PackageDetailsState>(
                    builder:
                        (BuildContext context, PackageDetailsState state) =>
                        PackageDetailsPage(
                          packageDetailsState: state,
                        ),
                  ),
            },
          ),
        );
      },
    );
  }
}
