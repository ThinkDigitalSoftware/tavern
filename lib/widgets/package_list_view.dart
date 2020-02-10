import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/widgets/package_tile.dart';

class PackageListView extends StatefulWidget {
  final PageQuery pageQuery;

  const PackageListView({Key key, @required this.pageQuery})
      : assert(pageQuery != null),
        super(key: key);

  @override
  _PackageListViewState createState() => _PackageListViewState();
}

class _PackageListViewState extends State<PackageListView> {
  // used to reset the list when we change filter or sort types.
  Key pageWiseSliverListKey = GlobalKey();
  double opacity = 1;
  Map<int, PackageTile> oldPackages = {};

  @override
  Widget build(BuildContext context) {
    return PagewiseSliverList<Package>(
      key: pageWiseSliverListKey,
      pageSize: 10,
      pageFuture: (index) async {
        // page numbering starts at 1, so we need to add 1.
        const int offset = 1;
        final completer = Completer<Page>();
        HomeBloc homeBloc = context.bloc<HomeBloc>();
        homeBloc.add(
          GetPageOfPackagesEvent(
            pageNumber: index + offset,
            completer: completer,
            filterBy: homeBloc.state.filterType,
            sortBy: homeBloc.state.sortType,
          ),
        );
        return completer.future;
      },
      itemBuilder: (BuildContext context, Package entry, int index) {
        PackageTile packageTile = PackageTile(
          package: entry,
        );
        oldPackages[entry.hashCode] = packageTile;
        return packageTile;
      },
      loadingBuilder: (context) => Opacity(
        opacity: .5,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: opacity,
          child: Container(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(PackageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageQuery.filterType != widget.pageQuery.filterType ||
        oldWidget.pageQuery.sortType != widget.pageQuery.sortType) {
      setState(() {
        opacity = 0;
      });
      pageWiseSliverListKey = GlobalKey();
      setState(() {
        opacity = 1;
      });
    }
  }
}
