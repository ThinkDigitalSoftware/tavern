import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';

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

  int _currentSelection = 2;

  DateFormat _dateFormat = DateFormat("MMM d, yyyy");

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
                  backgroundColor: Color.fromRGBO(18, 32, 48, 1),
                  title: TextField(
                    controller: _searchController,
                    onChanged: (searchQuery) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Dart packages',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () async {
                      PubHtmlParsingClient client = PubHtmlParsingClient();
                      var result = await client.get(_searchController.text);
                      print(result);
                    }, //TODO: launch search with query
                  ),
                ),
                SliverList(delegate: SliverChildListDelegate([
                  Container(
                    color: Color.fromRGBO(18, 32, 48, 1),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: MaterialSegmentedControl(
                        children: _children(),
                        selectionIndex: _currentSelection,
                        borderColor: Color.fromRGBO(71, 99, 132, 1),
                        selectedColor: Theme.of(context).accentColor,
                        unselectedColor: Color.fromRGBO(18, 32, 48, 1),
                        borderRadius: 5.0,
                        onSegmentChosen: (index) {
                          setState(() {
                            _currentSelection = index;
                          });
                        },
                      ),
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
                          return GroovinExpansionTile(
                            title: Text(
                              _package.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("v "
                              + _package.latestVersion.major.toString()
                              + '.'
                              + _package.latestVersion.minor.toString()
                              + '.'
                              + _package.latestVersion.patch.toString()
                              + ' updated '
                              + _dateFormat.format(_package.dateModified),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Text(_package.description),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    ..._package.compatibilityTags.map<Widget>((t)=> Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: RaisedButton.icon(
                                        icon: Icon(GroovinMaterialIcons.tag),
                                        label: Text(t),
                                        disabledColor: Colors.blue[100],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              /*ListView.builder(
                                itemCount: _package.compatibilityTags.length,
                                itemBuilder: (context, index) {
                                  return Text(_package.compatibilityTags[index].toString());
                                },
                                scrollDirection: Axis.horizontal,
                              ),*/
                            ],
                            trailing: CircleAvatar(
                              child: _package.score == null ? Text('?') : Text(_package.score.toString()),
                            ),
                          );
                        /*return ListTile(
                          title: Text(
                            _package.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(_package.description),
                          trailing: CircleAvatar(
                            child: _package.score == null ? Text('?') : Text(_package.score.toString()),
                          ),
                        );*/
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
