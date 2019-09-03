import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/settings/settings_event.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsState settingsState;

  const SettingsScreen({Key key, @required this.settingsState})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            onTap: () {
              final SettingsBloc settingsBloc =
                  BlocProvider.of<SettingsBloc>(context);
              settingsBloc.dispatch(ToggleThemeEvent(context: context));
            },
          ),
          ListTile(
            title: DropdownButton<SortType>(
              items: [
                DropdownMenuItem(
                  child: Text('Overall Score (default)'),
                  value: SortType.overAllScore,
                ),
                DropdownMenuItem(
                  child: Text('Recently Updated'),
                  value: SortType.recentlyUpdated,
                ),
                DropdownMenuItem(
                  child: Text('Newest Package'),
                  value: SortType.newestPackage,
                ),
                DropdownMenuItem(
                  child: Text('Popularity'),
                  value: SortType.popularity,
                ),
                DropdownMenuItem(
                  child: Text('Search Relevance'),
                  value: SortType.searchRelevance,
                ),
              ],
              onChanged: (sortType) {
                settingsBloc.dispatch(SetSortTypeEvent(sortType: sortType));
              },
              value: widget.settingsState.sortBy,
              hint: Text('Default Feed Sort'),
              isExpanded: true,
            ),
          ),
          ListTile(
            title: DropdownButton<FilterType>(
              items: [
                DropdownMenuItem(
                  child: Text('All (default)'),
                  value: FilterType.all,
                ),
                DropdownMenuItem(
                  child: Text('Flutter'),
                  value: FilterType.flutter,
                ),
                DropdownMenuItem(
                  child: Text('Web'),
                  value: FilterType.web,
                ),
              ],
              onChanged: (filterType) =>
                  settingsBloc.dispatch(SetFilterTypeEvent(
                filterType: filterType,
              )),
              value: widget.settingsState.filterBy,
              hint: Text('Default Feed Filter'),
              isExpanded: true,
            ),
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListTile(
              title: Text('Version ${_packageInfo.version}'),
              subtitle:
                  Text('Authored by ThinkDigitalSoftware and GroovinChip'),
            ),
          )
        ],
      ),
    );
  }
}
