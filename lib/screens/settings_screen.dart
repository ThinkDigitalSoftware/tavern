import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String feedSortSelection;
  String feedFilterSelection;

  void toggleTheme() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
    print(DynamicTheme.of(context).brightness);
  }

  void handleFeedSortSelection(String selection) async {
    setState(() {
      feedSortSelection = selection;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FeedSortSelection', selection);
  }

  void handleFeedFilterSelection(String selection) async {
    setState(() {
      feedFilterSelection = selection;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FeedFilterSelection', selection);
  }

  void loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      feedSortSelection = prefs.get('FeedSortSelection') ?? '';
      feedFilterSelection = prefs.get('FeedFilterSelection') ?? '';
    });
  }

  bool interceptBackButton(stopDefaultButtonEvent) {
    Navigator.of(context).pushReplacementNamed('/');
    return true;
  }

  @override
  void initState() {
    loadFromPrefs();
    BackButtonInterceptor.add(interceptBackButton);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptBackButton);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Settings',
          style: TextStyle(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: DynamicTheme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Toggle Dark Theme',
            ), //TODO: change text based on which theme is on
            trailing: Icon(
                DynamicTheme.of(context).brightness == Brightness.light
                    ? Icons.brightness_3
                    : Icons.brightness_6),
            onTap: () => toggleTheme(),
          ),
          ListTile(
            title: DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Text('Overall Score (defualt)'),
                  value: 'OverallScore',
                ),
                DropdownMenuItem(
                  child: Text('Recently Updated'),
                  value: 'RecentlyUpdated',
                ),
                DropdownMenuItem(
                  child: Text('Newest Package'),
                  value: 'NewestPackage',
                ),
                DropdownMenuItem(
                  child: Text('Popularity'),
                  value: 'Popularity',
                ),
              ],
              onChanged: handleFeedSortSelection,
              value: feedSortSelection,
              hint: Text('Default Feed Sort'),
              isExpanded: true,
            ),
          ),
          ListTile(
            title: DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Text('All (defualt)'),
                  value: 'All',
                ),
                DropdownMenuItem(
                  child: Text('Flutter'),
                  value: 'Flutter',
                ),
                DropdownMenuItem(
                  child: Text('Web'),
                  value: 'Web',
                ),
              ],
              onChanged: handleFeedFilterSelection,
              value: feedFilterSelection,
              hint: Text('Default Feed Filter'),
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
