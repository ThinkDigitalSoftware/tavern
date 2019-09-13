import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/settings/settings_screen.dart';

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
    return Drawer(
        child: BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, SettingsState state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Container(
//            color: PubColors.darkColor,
//            height: 16,
//          ),
//          //Get under the status bar without losing dark color
//
//          Container(
//            color: PubColors.darkColor,
//            child: ListTile(
//              leading: Icon(
//                GroovinMaterialIcons.dart_logo,
//                color: Colors.blue,
//              ),
//              title: Text(
//                'pub.dev',
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 22,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//            ),
//          ),
//          ListTile(
//            title: Text(
//              'Settings',
//              style: TextStyle(
//                fontSize: 18,
//              ),
//            ),
//            trailing: Icon(Icons.settings),
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.pushNamed(context, '/settingsScreen');
//            },
//          ),

          Expanded(
            child: SettingsScreen(
              settingsState: state,
            ),
          ),
        ],
      ),
    ));
  }
}
