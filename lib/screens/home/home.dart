import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF122030),
        title: Image.asset('images/dart-packages-white.png'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFloatingBar(
            floating: true,
            snap: true,
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
              onPressed: () async {
                PubHtmlParsingClient client = PubHtmlParsingClient();
                var result = await client.get(_searchController.text);
                print(result);
              }, //TODO: launch search with query
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                //TODO: return 'Top Packages'
                return ListTile(
                  title: Text('$index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
