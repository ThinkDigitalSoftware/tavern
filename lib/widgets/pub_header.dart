import 'package:floating_search_bar/ui/sliver_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:pub_client/pub_client.dart';

class PubHeader extends StatefulWidget {
  @override
  _PubHeaderState createState() => _PubHeaderState();
}

class _PubHeaderState extends State<PubHeader> {
  TextEditingController _searchController = TextEditingController();

  Map<int, Widget> _children() => {
    0: Text('Flutter'),
    1: Text('Web'),
    2: Text('All'),
  };

  int _currentSelection = 2;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(18, 32, 48, 1),
      //child: Placeholder(),
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverFloatingBar(
            floating: true,
            snap: true,
            elevation: 2,
            backgroundColor: Color(0xFF35404d),
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
                /*PubHtmlParsingClient client = PubHtmlParsingClient();
                var result = await client.get(_searchController.text);
                print(result);*/
                print('not ready yet');
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
        ],
      ),
    );
  }
}
