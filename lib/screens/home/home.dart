import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pub_dev_client/widgets/default_pacakges_list.dart';
import 'package:pub_dev_client/widgets/main_drawer.dart';
import 'package:pub_dev_client/widgets/pub_header.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PubClient _client = PubClient();
  PubHtmlParsingClient _htmlParsingClient = PubHtmlParsingClient();
  Page firstPage;
  int FIRST_PAGE = 1;
  List<FullPackage> packagesFromPage = [];
  DateFormat _dateFormat = DateFormat("MMM d, yyyy");
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<int, Widget> _children() => {
    0: Text('Flutter'),
    1: Text('Web'),
    2: Text('All'),
  };

  int _currentSelection = 2;

  TextEditingController _searchController = TextEditingController();

  /// Takes a Page of Packages and gets the FullPackage
  /// equivalents of each Package
  void convertToFullPackagesFromPage(Page page) async {
    for (int i = 0; i < page.packages.length; i++) {
      String packageName = page.packages[i].name;
      try {
        FullPackage _fullPackage = await _htmlParsingClient.get(packageName);
        packagesFromPage.add(_fullPackage);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: Stack(
        children: <Widget>[
          FutureBuilder<Page>(
            future: _client.getPageOfPackages(1),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final page = snapshot.data;
                //convertToFullPackagesFromPage(page);
                //print(packagesFromPage.length);
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Theme.of(context).canvasColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      snap: true,
                      floating: true,
                      title: Text(
                        'Browse Packages',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                //unselectedColor: Provider.of<PubColors>(context).darkColor,
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
                        return MockPackageTile();
                      },
                      childCount: 15,
                      ),
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
              child: Material(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 16,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            //color: Colors.white,
                          ),
                          onPressed: () => _scaffoldKey.currentState.openDrawer(),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Search Dart packages',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  print(_searchController.text);
                                }, //TODO: launch search with query
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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


class MockPackageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GroovinExpansionTile(
      title: Text(
        'mock_package',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "v " +
            '1' +
            '.' +
            '0' +
            '.' +
            '0' +
            ' updated ' +
            'June 26, 2019',
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Text('This is a package description for a mock package'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Row(
            //TODO: extract tags into their own widgets
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 30,
                  width: 86,
                  color: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: <Widget>[
                        Icon(GroovinMaterialIcons.tag, size: 16, color: Colors.black38,),
                        SizedBox(
                          width: 6,
                        ),
                        Text('Flutter', style: TextStyle(color: Colors.black38),),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 30,
                  width: 80,
                  color: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: <Widget>[
                        Icon(GroovinMaterialIcons.tag, size: 16, color: Colors.black38,),
                        SizedBox(
                          width: 6,
                        ),
                        Text('Web', style: TextStyle(color: Colors.black38),),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 30,
                  width: 72,
                  color: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: <Widget>[
                        Icon(GroovinMaterialIcons.tag, size: 16, color: Colors.black38,),
                        SizedBox(
                          width: 6,
                        ),
                        Text('All', style: TextStyle(color: Colors.black38),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      trailing: CircleAvatar(
        child: Text('100'),
      ),
    );
  }
}

//TODO: pass this class down from above MaterialApp with Provider
class PubColors {
  Color darkColor = Color.fromRGBO(18, 32, 48, 1);
}