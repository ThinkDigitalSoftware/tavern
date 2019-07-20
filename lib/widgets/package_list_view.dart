import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/widgets/package_tile.dart';

class PackageListView extends StatelessWidget {
  final Page page;

  const PackageListView({Key key, @required this.page})
      : assert(page != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagewiseSliverList<Package>(
      pageSize: 10,
      pageFuture: (index) async {
        final completer = Completer<Page>();
        HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
        homeBloc.dispatch(
          GetPageOfPackagesEvent(
            completer: completer,
            filterBy: homeBloc.currentState.filterType,
            sortBy: homeBloc.currentState.sortType,
          ),
        );
        return completer.future;
      },
      itemBuilder: (BuildContext context, entry, int index) {
        return PackageTile(
          package: page[index],
        );
      },
    );
  }
}
