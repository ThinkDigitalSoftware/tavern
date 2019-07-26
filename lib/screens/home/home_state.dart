import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/src/convert.dart';

@immutable
class HomeState {
  final Page page;
  final FilterType filterType;
  final SortType sortType;

  const HomeState({
    @required this.page,
    @required this.filterType,
    @required this.sortType,
  });

  HomeState copyWith({Page page, FilterType filterType, SortType sortType}) {
    return HomeState(
      page: page ?? this.page,
      filterType: filterType ?? this.filterType,
      sortType: sortType ?? this.sortType,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'page': page.toJson(),
        'sortType': convertSortTypeToString(sortType),
        'filterType': convertFilterTypeToString(filterType),
      };

  factory HomeState.fromJson(Map<String, dynamic> json) {
    return HomeState(
      page: Page.fromJson(json['page']),
      sortType: convertStringToSortType(json['sortType']),
      filterType: convertStringToFilterType(json['filterType']),
    );
  }
}

class InitialHomeState extends HomeState {
  const InitialHomeState()
      : super(
          page: null,
          filterType: FilterType.all,
          sortType: SortType.overAllScore,
        );
}
