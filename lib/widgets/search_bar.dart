import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:tavern/src/pub_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DynamicTheme.of(context).brightness == Brightness.light
          ? Theme.of(context).canvasColor
          : PubColors.darkAccent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                ),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
            ),
            Text(
              'Search Dart packages',
              style: TextStyle(
                color: DynamicTheme.of(context).brightness == Brightness.light
                    ? PubColors.searchBarItemsColor
                    : Colors.white,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.search,
                color: DynamicTheme.of(context).brightness == Brightness.light
                    ? PubColors.searchBarItemsColor
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
