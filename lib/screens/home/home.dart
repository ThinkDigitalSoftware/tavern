import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart' hide showSearch;
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:pub_dev_client/screens/search_screen.dart';
import 'package:pub_dev_client/widgets/main_drawer.dart';
import 'package:pub_dev_client/widgets/material_search.dart';
import 'package:pub_dev_client/widgets/package_tile.dart';
import 'package:pub_dev_client/widgets/platform_filter.dart';
import 'package:pub_dev_client/widgets/pub_logo.dart';
import 'package:pub_dev_client/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _htmlParsingClient = PubHtmlParsingClient();

  Page firstPage;

  /// Defaults to 1 for the first page
  int currentPage = 1;

  List<FullPackage> packagesFromPage = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String titleFilter = "Top";

  int _currentSelection = 2;

  ScrollController _scrollController;

  SortType sortType = SortType.overAllScore;
  FilterType filterType = FilterType.all;

  void _handleFilterSelection(String selection, List<Package> packages) {
    switch (selection) {
      case 'Overall Score':
        setState(() {
          titleFilter = 'Top';
          sortType = SortType.overAllScore;
        });
        break;
      case 'Recently Updated':
        setState(() {
          titleFilter = 'Updated';
          sortType = SortType.recentlyUpdated;
        });
        break;
      case 'Newest Package':
        setState(() {
          titleFilter = 'New';
          sortType = SortType.newestPackage;
        });
        break;
      case 'Popularity':
        setState(() {
          titleFilter = 'Popular';
          sortType = SortType.popularity;
        });
        break;
      default:
        break;
    }
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sort = prefs.get('FeedSortSelection');
    setState(() {
      switch (sort) {
        case 'OverallScore':
          sortType = SortType.overAllScore;
          titleFilter = "Top";
          break;
        case 'RecentlyUpdated':
          sortType = SortType.recentlyUpdated;
          titleFilter = 'Updated';
          break;
        case 'NewestPackage':
          sortType = SortType.newestPackage;
          titleFilter = 'New';
          break;
        case 'Popularity':
          sortType = SortType.popularity;
          titleFilter = 'Popular';
          break;
        default:
          break;
      }
      String filter = prefs.get('FeedFilterSelection');
      switch (filter) {
        case 'All':
          filterType = FilterType.all;
          _currentSelection = 2;
          break;
        case 'Flutter':
          filterType = FilterType.flutter;
          _currentSelection = 0;
          break;
        case 'Web':
          filterType = FilterType.web;
          _currentSelection = 1;
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    loadPreferences();
    super.initState();
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
        child: Stack(
          children: <Widget>[
            FutureBuilder<Page>(
              future: _htmlParsingClient.getPageOfPackages(
                pageNumber: currentPage,
                sortBy: sortType,
                filterBy: filterType,
              ),
              builder: (context, snapshot) {
                var animationController = AnimationController(
                    duration: Duration(seconds: 1), vsync: this);
                animationController.forward();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return PubDevAnimatedLogo(
                      animationController: animationController);
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  animationController.dispose();
                  final page = snapshot.data;

                  return CustomScrollView(
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
                          PopupMenuButton(
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
                                value: 'Overall Score',
                              ),
                              PopupMenuItem(
                                child: Text('Recently Updated'),
                                value: 'Recently Updated',
                              ),
                              PopupMenuItem(
                                child: Text('Newest Package'),
                                value: 'Newest Package',
                              ),
                              PopupMenuItem(
                                child: Text('Popularity'),
                                value: 'Popularity',
                              ),
                            ],
                            onSelected: (selection) =>
                                _handleFilterSelection(
                                    selection, page.packages),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize:
                          Size(MediaQuery
                              .of(context)
                              .size
                              .width, 40),
                          child: PlatformFilter(
                            value: _currentSelection,
                            onSegmentChosen: (index) {
                              setState(() {
                                _currentSelection = index;
                                switch (_currentSelection) {
                                  case 0:
                                    filterType = FilterType.flutter;
                                    break;
                                  case 1:
                                    filterType = FilterType.web;
                                    break;
                                  case 2:
                                    filterType = FilterType.all;
                                    break;
                                  default:
                                    break;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return PackageTile(
                              page: page,
                              index: index,
                            );
                          },
                          childCount: page.packages.length,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ListTile(
                            leading: currentPage == 1
                                ? Container(
                              width: 1,
                            )
                                : FlatButton(
                              child: Text('Page ${currentPage - 1}'),
                              onPressed: () {
                                setState(() {
                                  currentPage--;
                                  _scrollController.animateTo(0,
                                      curve: Curves.linear,
                                      duration:
                                      Duration(milliseconds: 250));
                                });
                              },
                            ),
                            trailing: FlatButton(
                              child: Text('Page ${currentPage + 1}'),
                              onPressed: () {
                                setState(() {
                                  currentPage++;
                                  _scrollController.animateTo(0.0,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 250));
                                });
                              },
                            ),
                          ),

                          /// Acts as a buffer since the last item in the list
                          /// will be hidden under the search bar
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                          ),
                        ]),
                      ),
                    ],
                  );
                }
              },
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
        ),
      ),
    );
  }
}
