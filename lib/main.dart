import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_client/screens/search_screen.dart';
import 'screens/home/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(PubDevClientApp());

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PubColors>(
      builder: (context) => PubColors(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Metropolis',
          accentColor: Color(0xFF38bffc),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: Home(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/SearchScreen": (BuildContext context) => SearchScreen(),
        },
      ),
    );
  }
}

class PubColors {
  Color darkColor = Color.fromRGBO(18, 32, 48, 1);
}