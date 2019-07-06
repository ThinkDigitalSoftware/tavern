import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter/material.dart' as prefix0;
import 'package:pub_dev_client/widgets/material_search.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Hero(
                tag: 'SearchBar',
                child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Search Dart packages',
                                icon: IconButton(
                                  padding: EdgeInsets.only(left: 8),
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.search,
                                  ),
                                )),
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
      ),
    );
  }
}

class PubSearchDelegate extends SearchDelegate {
  @override
  Widget buildResults(BuildContext context) {
    //TODO: Implement BuildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: prefix0.Colors.white,
          child: ListTile(
            title: Text("Search Suggestion"),
          ),
        );
      },
    );
  }

  @override
  Widget buildSearchBar({
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputAction textInputAction,
    Function(String) onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Hero(
        tag: 'SearchBar',
        child: Material(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: MediaQuery.of(context).size.width - 16,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textInputAction: textInputAction,
                    onSubmitted: onSubmitted,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Search Dart packages',
                      icon: IconButton(
                        padding: EdgeInsets.only(left: 8),
                        icon: Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                        ),
                        onPressed: () {
                          showResults(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
