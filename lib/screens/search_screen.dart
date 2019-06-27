import 'package:flutter/material.dart';

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
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 16,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            //controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Search Dart packages',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.search,
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
      ),
    );
  }
}
