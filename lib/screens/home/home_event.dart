import 'dart:async';

import 'package:flutter/cupertino.dart' hide Page;
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class HomeEvent {}

class GetPageOfPackagesEvent extends HomeEvent {
  final int pageNumber;
  final SortType sortBy;
  final FilterType filterBy;
  final Completer<Page> completer;

  GetPageOfPackagesEvent({
    this.pageNumber = 1,
    @required this.sortBy,
    @required this.filterBy,
    this.completer,
  })  : assert(sortBy != null, "sortBy cannot be null."),
        assert(filterBy != null, "filterBy cannot be null.");

  GetPageOfPackagesEvent copyWith({
    int pageNumber,
    SortType sortBy,
    FilterType filterBy,
  }) {
    return GetPageOfPackagesEvent(
      pageNumber: pageNumber ?? this.pageNumber,
      sortBy: sortBy ?? this.sortBy,
      filterBy: filterBy ?? this.filterBy,
    );
  }
}

class ChangeFilterTypeEvent extends HomeEvent {
  final FilterType filterType;

  ChangeFilterTypeEvent({@required this.filterType});
}

class ChangeBottomNavigationBarIndex extends HomeEvent {
  final int index;

  ChangeBottomNavigationBarIndex(this.index);
}

class ShowPackageDetailsPageEvent extends HomeEvent {
  final BuildContext context;
  final Package package;

  ShowPackageDetailsPageEvent({@required this.context, @required this.package})
      : assert(context != null),
        assert(package != null);
}
