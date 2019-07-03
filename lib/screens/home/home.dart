import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pub_dev_client/screens/search_screen.dart';
import 'package:pub_dev_client/widgets/main_drawer.dart';
import 'package:pub_dev_client/widgets/package_tile.dart';

import '../../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PubHtmlParsingClient _htmlParsingClient = PubHtmlParsingClient();

  Page firstPage;

  /// Defaults to 1 for the first page
  int currentPage = 1;

  List<FullPackage> packagesFromPage = [];

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  String titleFilter = "Top";

  Map<int, Widget> _children() => {
    0: Text('Flutter'),
    1: Text('Web'),
    2: Text('All'),
  };

  int _currentSelection = 2;

  ScrollController _scrollController;

  void _handleFilterSelection(String selection) {
    switch (selection) {
      case 'Overall Score':
        setState(() {
          titleFilter = 'Top';
        });
        break;
      case 'Recently Updated':
        setState(() {
          titleFilter = 'Updated';
        });
        break;
      case 'Newest Package':
        setState(() {
          titleFilter = 'New';
        });
        break;
      case 'Popularity':
        setState(() {
          titleFilter = 'Popular';
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
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
      body: Stack(
        children: <Widget>[
          FutureBuilder<Page>(
            future: _htmlParsingClient.getPageOfPackages(currentPage),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final page = snapshot.data;

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Theme.of(context).canvasColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      snap: true,
                      floating: true,
                      title: Text(
                        'Browse $titleFilter Packages',
                        style: TextStyle(
                          color: DynamicTheme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: <Widget>[
                        PopupMenuButton(
                          icon: Icon(
                            GroovinMaterialIcons.filter_outline,
                            color: DynamicTheme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          ),
                          itemBuilder: (context) => [
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
                          onSelected: _handleFilterSelection,
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size(MediaQuery.of(context).size.width, 40),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialSegmentedControl(
                                children: _children(),
                                selectionIndex: _currentSelection,
                                borderColor: Color.fromRGBO(71, 99, 132, 1),
                                selectedColor: Theme.of(context).accentColor,
                                unselectedColor: DynamicTheme.of(context).brightness == Brightness.light ? Theme.of(context).canvasColor : Provider.of<PubColors>(context).darkAccent,
                                borderRadius: 5.0,
                                onSegmentChosen: (index) {
                                  setState(() {
                                    _currentSelection = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
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
                          leading: currentPage == 1 ? Container(width: 1,) : FlatButton(
                            child: Text('Page ' + (currentPage - 1).toString()),
                            onPressed: () {
                              setState(() {
                                currentPage -= 1;
                                _scrollController.animateTo(0, curve: Curves.linear, duration: Duration(milliseconds: 250));
                              });
                            },
                          ),
                          trailing: FlatButton(
                            child: Text('Page ' + (currentPage + 1).toString()),
                            onPressed: () {
                              setState(() {
                                currentPage += 1;
                                _scrollController.animateTo(0.0, curve: Curves.linear, duration: Duration(milliseconds: 250));
                              });
                            },
                          ),
                        ),
                        /// Acts as a buffer since the last item in the list
                        /// will be hidden under the search bar
                        ListTile(
                          title: Text(''),
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
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => SearchScreen(),
                  ),
                ),
                child: Hero(
                  tag: 'SearchBar',
                  child: Material(
                    color: DynamicTheme.of(context).brightness == Brightness.light ? Theme.of(context).canvasColor : Provider.of<PubColors>(context).darkAccent,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
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
                              color: DynamicTheme.of(context).brightness == Brightness.light ? Provider.of<PubColors>(context).searchBarItemsColor : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.search,
                              color: DynamicTheme.of(context).brightness == Brightness.light ? Provider.of<PubColors>(context).searchBarItemsColor : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}