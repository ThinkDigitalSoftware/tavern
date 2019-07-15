import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tavern/screens/home/home.dart';
import 'package:tavern/screens/package_details_page.dart';
import 'package:tavern/screens/search_screen.dart';
import 'package:tavern/screens/settings_screen.dart';
import 'package:tavern/src/pub_colors.dart';

void main() {
  runApp(PubDevClientApp());
}

class PubDevClientApp extends StatelessWidget {
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
            home: Home(),
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              "/searchScreen": (BuildContext context) => SearchScreen(),
              "/SettingsScreen": (BuildContext context) => SettingsScreen(),
              PackageDetailsPage.routeName: (context) => PackageDetailsPage(),
            },
          ),
        );
      },
    );
  }
}
