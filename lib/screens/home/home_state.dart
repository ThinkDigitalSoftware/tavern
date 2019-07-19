import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

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
}

class InitialHomeState extends HomeState {
  const InitialHomeState()
      : super(
          page: null,
          filterType: FilterType.all,
          sortType: SortType.overAllScore,
        );
}
