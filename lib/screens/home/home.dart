import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:google_fonts/google_fonts.dart';

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
  double fontRatio;

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
  void didChangeDependencies() {
    fontRatio = MediaQuery.of(context).size.width / 17;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double expandedHeight = 200;
    final double bottomHeight = 80;
    final double searchBarHeight = 30;
    final double headerTextPadding =
        (expandedHeight - (bottomHeight + searchBarHeight + 20)) /
            2; // 20 accounts for extra padding
    HomeBloc _homeBloc = BlocProvider.of<HomeBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
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
                          elevation: 3,
                          forceElevated: true,
                          backgroundColor:
                              DynamicTheme.of(context).data.appBarTheme.color,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          snap: true,
                          floating: true,
                          expandedHeight: expandedHeight,
                          title: headerTextWidget,
                          bottom: PreferredSize(
                            preferredSize: Size(
                                MediaQuery.of(context).size.width,
                                bottomHeight),
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Hero(
                                    tag: 'SearchBar',
                                    child: SearchBar(),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      Routes.searchScreen,
                                      arguments: PubSearchDelegate(
                                        searchBloc: BlocProvider.of<SearchBloc>(
                                            context),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 8.0, top: 18),
                                  child: PlatformFilter(
                                    value: widget.homeState.filterType,
                                    onSegmentChosen: (filterType) {
                                      _homeBloc.add(
                                        ChangeFilterTypeEvent(
                                          filterType: filterType,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(top: 10),
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
                    MainDrawer(),
                  ],
                  onPageChanged: (index) {
                    _homeBloc.add(
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
              icon: Icon(Icons.star_border),
              activeIcon: Icon(Icons.star),
              title: Text("Favorites")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
          _homeBloc.add(ChangeBottomNavigationBarIndex(index));
        },
      ),
    );
  }

  Widget get headerTextWidget {
    return AutoSizeText(
      'Top ${_convertFilterTypeToString(widget.homeState.filterType)}packages',
      minFontSize: fontRatio.ceilToDouble(),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool get showLogo => widget.homeState is InitialHomeState || showAnimation;

  String _convertFilterTypeToString(FilterType filterType) {
    switch (filterType) {
      case FilterType.flutter:
        return 'Flutter ';
      case FilterType.web:
        return 'Web ';
      case FilterType.all:
      default:
        return '';
    }
  }
}

bool isLightTheme(BuildContext context) {
  return DynamicTheme.of(context).brightness == Brightness.light;
}
