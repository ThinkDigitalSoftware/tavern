import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_client/screens/search_screen.dart';
import 'screens/home/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(PubDevClientApp());

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        fontFamily: 'Metropolis',
        accentColor: Color(0xFF38bffc),
        brightness: brightness,
        /*appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),*/
      ),
      themedWidgetBuilder: (context, theme) {
        return Provider<PubColors>(
          builder: (context) => PubColors(),
          child: MaterialApp(
            theme: theme,
            home: Home(),
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              "/SearchScreen": (BuildContext context) => SearchScreen(),
            },
          ),
        );
      },
    );
  }
}

class PubColors {
  Color darkColor = Color.fromRGBO(18, 32, 48, 1);
  Color darkAccent = Colors.grey[800];
  Color searchBarItemsColor = Colors.black45;
}