import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home/home.dart';

void main() => runApp(PubDevClientApp());

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Metropolis',
        accentColor: Color(0xFF38bffc),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}