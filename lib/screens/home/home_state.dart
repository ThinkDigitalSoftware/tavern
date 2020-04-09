import 'package:flutter/material.dart' hide Page;
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/src/convert.dart';

@immutable
class HomeState {
  final Page page;
  final FilterType filterType;
  final SortType sortType;
  final int bottomNavigationBarIndex;

  const HomeState({
    @required this.page,
    @required this.filterType,
    @required this.sortType,
    @required this.bottomNavigationBarIndex,
  });

  HomeState copyWith({
    Page page,
    FilterType filterType,
    SortType sortType,
    int bottomNavigationBarIndex,
  }) {
    return HomeState(
      page: page ?? this.page,
      filterType: filterType ?? this.filterType,
      sortType: sortType ?? this.sortType,
      bottomNavigationBarIndex:
          bottomNavigationBarIndex ?? this.bottomNavigationBarIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page.toJson(),
        'sortType': convertSortTypeToString(sortType),
        'filterType': convertFilterTypeToString(filterType),
        'bottomNavigationBarIndex': bottomNavigationBarIndex,
      };

  factory HomeState.fromJson(Map<String, dynamic> json) {
    return HomeState(
        page: Page.fromJson(json['page']),
        sortType: convertStringToSortType(json['sortType']),
        filterType: convertStringToFilterType(json['filterType']),
        bottomNavigationBarIndex: json['bottomNavigationBarIndex'] ?? 0);
  }
}

class InitialHomeState extends HomeState {
  const InitialHomeState()
      : super(
          page: null,
          filterType: FilterType.all,
          sortType: SortType.overAllScore,
          bottomNavigationBarIndex: 0,
        );
}
