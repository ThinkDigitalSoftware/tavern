import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();
  PubClient _client = PubClient();
  PubHtmlParsingClient _htmlParsingClient = PubHtmlParsingClient();

  Map<int, Widget> _children() => {
    0: Text('Flutter'),
    1: Text('Web'),
    2: Text('All'),
  };

  int _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF122030),
        title: Image.asset('images/dart-packages-white.png'),
      ),
      body: FutureBuilder<Page>(
        future: _client.getPageOfPackages(1),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final page = snapshot.data;
            return CustomScrollView(
              slivers: <Widget>[
                SliverFloatingBar(
                  floating: true,
                  snap: true,
                  elevation: 2,
                  title: TextField(
                    controller: _searchController,
                    onChanged: (searchQuery) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Dart packages',
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      PubHtmlParsingClient client = PubHtmlParsingClient();
                      var result = await client.get(_searchController.text);
                      print(result);
                    }, //TODO: launch search with query
                  ),
                ),
                SliverList(delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: MaterialSegmentedControl(
                      children: _children(),
                      selectionIndex: _currentSelection,
                      borderColor: Color.fromRGBO(71, 99, 132, 1),
                      selectedColor: Theme.of(context).accentColor,
                      unselectedColor: Colors.white,
                      borderRadius: 32.0,
                      onSegmentChosen: (index) {
                        setState(() {
                          _currentSelection = index;
                        });
                      },
                    ),
                  ),
                ])),
                SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                  //TODO: return 'Top Packages'
                  return FutureBuilder<FullPackage>(
                    future: _htmlParsingClient.get(page.packages[index].name),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        FullPackage _package = snapshot.data;
                        //print(_package.name + " " + _package.score.toString());
                        return ListTile(
                          title: Text(_package.name),
                          trailing: CircleAvatar(
                            child: Text(_package.score.toString()),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
                childCount: page.packages.length
                )),
              ],
            );
          }
        },
      ),
    );
  }
}
