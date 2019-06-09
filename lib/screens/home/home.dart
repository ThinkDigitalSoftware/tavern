import 'package:flutter/material.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

class Home extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 8),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFloatingBar(
              leading: Icon(
                GroovinMaterialIcons.dart_logo,
                color: Theme.of(context).accentColor, // change to specific dart color
              ),
              title: TextField(
                controller: _searchController,
                onChanged: (searchQuery) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search pub.dev',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
