import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class HomeEvent {}

class GetPageOfPackagesEvent extends HomeEvent {
  final int pageNumber;
  final SortType sortBy;
  final FilterType filterBy;

  GetPageOfPackagesEvent({
    this.pageNumber = 1,
    this.sortBy,
    this.filterBy,
  });

  GetPageOfPackagesEvent copyWith(
      {int pageNumber, SortType sortBy, FilterType filterBy}) {
    return GetPageOfPackagesEvent(
        pageNumber: pageNumber ?? this.pageNumber,
        sortBy: sortBy ?? this.sortBy,
        filterBy: filterBy ?? this.filterBy);
  }
}

class ChangeFilterTypeEvent extends HomeEvent {
  final FilterType filterType;

  ChangeFilterTypeEvent(this.filterType);
}
