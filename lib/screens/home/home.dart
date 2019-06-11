import 'package:flutter/material.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF122030),
            title: Image.asset('images/dart-packages-white.png'),
          ),
          SliverFloatingBar(
            floating: true,
            elevation: 4,
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
              onPressed: () {}, //TODO: launch search with query
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              //TODO: return 'Top Packages'
              return ListTile(
                title: Text('$index'),
              );
            })
          ),
        ],
      ),
    );
  }
}
