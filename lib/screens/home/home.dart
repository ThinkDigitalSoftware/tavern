import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide showSearch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/search_screen.dart';
import 'package:tavern/widgets/main_drawer.dart';
import 'package:tavern/widgets/material_search.dart';
import 'package:tavern/widgets/package_list_view.dart';
import 'package:tavern/widgets/platform_filter.dart';
import 'package:tavern/widgets/search_bar.dart';
import 'package:tavern/widgets/tavern_logo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  HomeBloc homeBloc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String titleFilter = "Top";

  SortType sortType = SortType.overAllScore;
  FilterType filterType = FilterType.all;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.dispatch(GetPageOfPackagesEvent());
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: SafeArea(
        child: BlocBuilder(
          bloc: homeBloc,
          builder: (BuildContext context, HomeState state) {
            if (state is InitialHomeState) {
              return TavernAnimatedLogo();
            }
            return Stack(
              children: <Widget>[
                CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Theme
                          .of(context)
                          .canvasColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      snap: true,
                      floating: true,
                      title: Text(
                        'Browse $titleFilter Packages',
                        style: TextStyle(
                          color: DynamicTheme
                              .of(context)
                              .brightness ==
                              Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: <Widget>[
                        PopupMenuButton<SortType>(
                          icon: Icon(
                            GroovinMaterialIcons.filter_outline,
                            color: DynamicTheme
                                .of(context)
                                .brightness ==
                                Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          itemBuilder: (context) =>
                          [
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
                          onSelected: (selection) =>
                              homeBloc.dispatch(
                                  GetPageOfPackagesEvent(sortBy: selection)),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize:
                        Size(MediaQuery
                            .of(context)
                            .size
                            .width, 40),
                        child: PlatformFilter(
                          value: state.filterType,
                          onSegmentChosen: (filterType) {
                            homeBloc
                                .dispatch(ChangeFilterTypeEvent(filterType));
                          },
                        ),
                      ),
                    ),
                    PackageListView(page: state.page),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        return showSearch(
                          context: context,
                          delegate: PubSearchDelegate(),
                        );
                      },
                      child: Hero(
                        tag: 'SearchBar',
                        child: SearchBar(scaffoldKey: _scaffoldKey),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
