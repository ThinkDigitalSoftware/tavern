import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_dev_client/screens/search_screen.dart';
import 'package:pub_dev_client/src/pub_colors.dart';

import 'screens/home/home.dart';

void main() {
  runApp(PubDevClientApp());
}

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            fontFamily: 'Metropolis',
            accentColor: Color(0xFF38bffc),
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return Provider<PubColors>(
          builder: (context) => PubColors(),
          child: MaterialApp(
            theme: theme,
            home: Home(),
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              "/searchScreen": (BuildContext context) => SearchScreen(),
            },
          ),
        );
      },
    );
  }
}
