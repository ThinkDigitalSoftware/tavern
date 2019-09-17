import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide showSearch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/search/search_screen.dart';
import 'package:tavern/screens/subscriptions/subscriptions_page.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/widgets/main_drawer.dart';
import 'package:tavern/widgets/package_list_view.dart';
import 'package:tavern/widgets/platform_filter.dart';
import 'package:tavern/widgets/search_bar.dart';
import 'package:tavern/widgets/tavern_logo.dart';

class Home extends StatefulWidget {
  final HomeState homeState;

  const Home({Key key, @required this.homeState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  PageController _pageController;
  bool showAnimation = true;
  VoidCallback _changePageIndexListener;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(
        initialPage: widget.homeState.bottomNavigationBarIndex ?? 0);
    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc _homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: showLogo
          ? TavernAnimatedLogo()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                          elevation: 0,
                          backgroundColor: Theme.of(context).canvasColor,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          snap: true,
                          floating: true,
                          title: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.searchScreen,
                                arguments: PubSearchDelegate(
                                  searchBloc:
                                      BlocProvider.of<SearchBloc>(context),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'SearchBar',
                              child: SearchBar(scaffoldKey: _scaffoldKey),
                            ),
                          ),
                          bottom: PreferredSize(
                            preferredSize:
                                Size(MediaQuery.of(context).size.width, 80),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Browse ${_convertFilterTypeToString(widget.homeState.filterType)} Packages',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .title
                                          .copyWith(
                                            color: DynamicTheme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    PopupMenuButton<SortType>(
                                      initialValue: widget.homeState.sortType,
                                      icon: Icon(
                                        GroovinMaterialIcons.filter_outline,
                                        color: DynamicTheme.of(context)
                                            .brightness ==
                                            Brightness.light
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
                                      onSelected: (selection) =>
                                          _homeBloc.dispatch(
                                            GetPageOfPackagesEvent(
                                              sortBy: selection,
                                              filterBy: widget.homeState
                                                  .filterType,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                                PlatformFilter(
                                  value: widget.homeState.filterType,
                                  onSegmentChosen: (filterType) {
                                    _homeBloc.dispatch(
                                      ChangeFilterTypeEvent(
                                        filterType: filterType,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        PackageListView(
                          pageQuery: PageQuery(
                            filterType: widget.homeState.filterType,
                            sortType: widget.homeState.sortType,
                            pageNumber: widget.homeState.page.pageNumber,
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                        ),
                      ],
                    ),
                    SubscriptionsPage(),
                  ],
                  onPageChanged: (index) {
                    _homeBloc.dispatch(
                      ChangeBottomNavigationBarIndex(index),
                    );
                  },
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.homeState.bottomNavigationBarIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(GroovinMaterialIcons.package_variant_closed),
            activeIcon: Icon(GroovinMaterialIcons.package_variant),
            title: Text("Packages"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              title: Text("Favorites")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
            case 1:
              {
                _pageController.jumpToPage(index);
                _homeBloc.dispatch(ChangeBottomNavigationBarIndex(index));
                break;
              }
            case 2:
              {
                _scaffoldKey.currentState.openDrawer();
              }
          }
        },
      ),
    );
  }

  bool get showLogo => widget.homeState is InitialHomeState || showAnimation;

  String _convertFilterTypeToString(FilterType filterType) {
    switch (filterType) {
      case FilterType.flutter:
        return 'Flutter';
      case FilterType.web:
        return 'Web';
      case FilterType.all:
      default:
        return 'Dart';
    }
  }
}
