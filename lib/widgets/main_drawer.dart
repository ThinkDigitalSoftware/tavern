import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pub_dev_client/src/pub_colors.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    void toggleTheme() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);
      print(DynamicTheme.of(context).brightness);
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          //Get under the status bar without losing dark color
          Container(
            color: Provider.of<PubColors>(context).darkColor,
            height: 16,
          ),
          Container(
            color: Provider.of<PubColors>(context).darkColor,
            child: ListTile(
              leading: Icon(
                GroovinMaterialIcons.dart_logo,
                color: Colors.blue,
              ),
              title: Text(
                'pub.dev',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Getting Started:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          GroovinExpansionTile(
            title: Text(
              'Flutter:',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            children: <Widget>[
              ListTile(
                title: Text('Using Packages'),
                trailing: Icon(Icons.launch),
                onTap:
                    () {}, //TODO: launch https://flutter.dev/docs/development/packages-and-plugins/using-packages
              ),
              ListTile(
                title: Text('Developing Packages and Plugins'),
                trailing: Icon(Icons.launch),
                onTap:
                    () {}, //TODO: launch https://flutter.dev/docs/development/packages-and-plugins/developing-packages
              ),
            ],
          ),
          GroovinExpansionTile(
            title: Text(
              'Web and Server:',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            children: <Widget>[
              ListTile(
                title: Text('Using Packages'),
                trailing: Icon(Icons.launch),
                onTap: () {}, //TODO: launch hhttps://dart.dev/guides/packages
              ),
              ListTile(
                title: Text('Publishing a Package'),
                trailing: Icon(Icons.launch),
                onTap:
                    () {}, //TODO: launch https://dart.dev/tools/pub/publishing
              ),
              ListTile(
                title: Text('Overview'),
                trailing: Icon(Icons.launch),
                onTap: () {}, //TODO: launch https://dart.dev/tools/pub/cmd
              ),
            ],
          ),
          Divider(
            color: Provider.of<PubColors>(context).darkColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
            child: Row(
              children: <Widget>[
                Text(
                  'Settings:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Toggle Dark Theme',
              style: TextStyle(
                fontSize: 18,
              ),
            ), //TODO: change text based on which theme is on
            trailing: Icon(
                DynamicTheme.of(context).brightness == Brightness.light
                    ? Icons.brightness_3
                    : Icons.brightness_6),
            onTap: () {
              toggleTheme();
              Navigator.pop(context);
            },
          ),
          Expanded(child: Container()),
          Divider(
            color: Provider.of<PubColors>(context).darkColor,
          ),
          ListTile(
            title: Text('Version ${_packageInfo.version}'),
            subtitle: Text('Authored by ThinkDigitalSoftware and GroovinChip'),
          ),
        ],
      ),
    );
  }
}
