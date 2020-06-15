import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/publisher_package/publisher_bloc.dart';
import 'package:tavern/screens/publisher_package/publisher_event.dart';
import 'package:tavern/widgets/package_tile.dart';

class PublisherListView extends StatefulWidget {
  final PageQuery pageQuery;

  const PublisherListView({Key key, @required this.pageQuery})
      : assert(pageQuery != null),
        super(key: key);

  @override
  _PublisherListViewState createState() => _PublisherListViewState();
}

class _PublisherListViewState extends State<PublisherListView> {
  // used to reset the list when we change filter or sort types.
  Key pageWiseSliverListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PagewiseSliverList<Package>(
      key: pageWiseSliverListKey,
      pageSize: 10,
      pageFuture: (index) async {
        // page numbering starts at 1, so we need to add 1.
        const int offset = 1;
        final completer = Completer<Page>();
        PublisherBloc publisherBloc = BlocProvider.of<PublisherBloc>(context);
        publisherBloc.add(
          GetPageOfPublisherPackagesEvent(
              pageNumber: index + offset,
              completer: completer,
              publisherName: widget.pageQuery.publisherName),
        );
        return completer.future;
      },
      itemBuilder: (BuildContext context, entry, int index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PackageTile(
              package: entry,
            ),
          ],
        );
      },
      loadingBuilder: (context) => Opacity(
        opacity: .5,
        child: ListTile(
          title: Text("Loading"),
        ),
      ),
    );
  }

  // @override
  // void didUpdateWidget(PublisherListView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // if (oldWidget.pageQuery..pageNumber != widget.pageQuery.filterType ||
  //   //     oldWidget.pageQuery.sortType != widget.pageQuery.sortType) {
  //   pageWiseSliverListKey = GlobalKey();
  //   //}
  // }
}
