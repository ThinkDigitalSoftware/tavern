import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/src/pub_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = HomeBloc.of(context);
    final HomeState state = homeBloc.state;
    return Material(
      color: DynamicTheme.of(context).brightness == Brightness.light
          ? Theme.of(context).canvasColor
          : PubColors.gunmetal,
      shadowColor: PubColors.gunmetal,
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
              padding: EdgeInsets.only(),
              child: SafeArea(
                child: PopupMenuButton<SortType>(
                  initialValue: state.sortType,
                  offset: Offset(0, 500),
                  tooltip: 'Sort',
                  icon: Icon(
                    GroovinMaterialIcons.filter_outline,
                    color:
                        DynamicTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Overall Score'),
                      value: SortType.overAllScore,
                    ),
                    PopupMenuItem(
                      child: Text('Recently Updated'),
                      value: SortType.recentlyUpdated,
                    ),
                    PopupMenuItem(
                      child: Text('Newest Package'),
                      value: SortType.newestPackage,
                    ),
                    PopupMenuItem(
                      child: Text('Popularity'),
                      value: SortType.popularity,
                    ),
                  ],
                  onSelected: (selection) {
                    return homeBloc.add(
                      GetPageOfPackagesEvent(
                        sortBy: selection,
                        filterBy: state.filterType,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 0, 10),
              child: Text(
                'Search packages',
                style: TextStyle(
                  color: DynamicTheme.of(context).brightness == Brightness.light
                      ? PubColors.searchBarItemsColor
                      : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.search,
                color: DynamicTheme.of(context).data.iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
