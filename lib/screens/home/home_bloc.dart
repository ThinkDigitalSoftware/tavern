import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavern/screens/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => InitialHomeState();
  final _htmlParsingClient = PubHtmlParsingClient();

  HomeBloc() {
    loadPreferences().then((homePreferences) {
      dispatch(GetPageOfPackagesEvent(
          pageNumber: 1,
          sortBy: homePreferences.sortType,
          filterBy: homePreferences.filterType));
    });
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetPageOfPackagesEvent) {
      Page page = await _htmlParsingClient.getPageOfPackages(
          pageNumber: event.pageNumber,
          sortBy: event.sortBy,
          filterBy: event.filterBy);
      yield currentState.copyWith(
          page: page, filterType: event.filterBy, sortType: event.sortBy);
    }
    if (event is ChangeFilterTypeEvent) {
      dispatch(GetPageOfPackagesEvent(
          pageNumber: currentState.page.pageNumber,
          sortBy: currentState.sortType,
          filterBy: event.filterType));
    }
  }

  Future<HomePreferences> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SortType sortType;
    FilterType filterType;

    String filter = prefs.get('FeedFilterSelection');
    switch (filter) {
      case 'All':
        filterType = FilterType.all;
        break;
      case 'Flutter':
        filterType = FilterType.flutter;
        break;
      case 'Web':
        filterType = FilterType.web;
        break;
      default:
        break;
    }
    return HomePreferences(sortType: sortType, filterType: filterType);
  }
}

class HomePreferences {
  final SortType sortType;
  final FilterType filterType;

  HomePreferences({
    @required this.sortType,
    @required this.filterType,
  });
}
