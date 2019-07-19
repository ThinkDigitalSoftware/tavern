import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/widgets/package_tile.dart';

class PackageListView extends StatelessWidget {
  final Page page;

  const PackageListView({Key key, @required this.page})
      : assert(page != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PackageTile(
            page: page,
            index: index,
          );
        },
        childCount: page.packages.length,
      ),
    );
  }
}
