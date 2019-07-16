import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/widgets/package_tile.dart';

class PackageListView extends StatefulWidget {
  final Page page;

  const PackageListView({Key key, @required this.page}) : super(key: key);

  @override
  _PackageListViewState createState() => _PackageListViewState();
}

class _PackageListViewState extends State<PackageListView> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PackageTile(
            page: widget.page,
            index: index,
          );
        },
        childCount: widget.page.packages.length,
      ),
    );
  }
}
