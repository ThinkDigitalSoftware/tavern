import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/src/cache.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final PubHtmlParsingClient client;
  @override
  HomeState get initialState => InitialHomeState();
  PageRepository _pageRepository;

  HomeBloc({@required this.client}) {
    _loadPreferences().then((homePreferences) {
      dispatch(GetPageOfPackagesEvent(
          pageNumber: 1,
          sortBy: homePreferences.sortType,
          filterBy: homePreferences.filterType));
    });
    _pageRepository = PageRepository(client: client);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetPageOfPackagesEvent) {
      Page page;
      final pageQuery = PageQuery(
          sortType: event.sortBy,
          filterType: event.filterBy,
          pageNumber: event.pageNumber);
      page = await _pageRepository.get(pageQuery);
      yield currentState.copyWith(
        page: page,
        filterType: event.filterBy,
        sortType: event.sortBy,
      );
      // for queries that need to be notified on the successful result.
      if (event.completer != null) {
        event.completer.complete(page);
      }
      return;
    }
    if (event is ChangeFilterTypeEvent) {
      dispatch(
        GetPageOfPackagesEvent(
          pageNumber: currentState.page.pageNumber,
          sortBy: currentState.sortType,
          filterBy: event.filterType,
        ),
      );
      return;
    }
  }

  Future<HomePreferences> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SortType sortType = SortType.overAllScore;
    FilterType filterType;

    String filter = prefs.get('feedFilterSelection');
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
        filterType = FilterType.all;
    }
    return HomePreferences(sortType: sortType, filterType: filterType);
  }

  @override
  HomeState fromJson(Map<String, dynamic> json) => HomeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(HomeState state) => state.toJson();
}

class HomePreferences {
  final SortType sortType;
  final FilterType filterType;

  HomePreferences({
    @required this.sortType,
    @required this.filterType,
  })
      : assert(sortType != null, "sortType cannot be null."),
        assert(filterType != null, "filterType cannot be null.");
}

/// Used as a data class for specifying details about queries in the PageClass
class PageQuery {
  final SortType sortType;
  final FilterType filterType;
  final int pageNumber;

  PageQuery({
    @required this.sortType,
    @required this.filterType,
    @required this.pageNumber,
  })
      : assert(sortType != null, "sortType cannot be null."),
        assert(filterType != null, "filterType cannot be null.");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PageQuery &&
              runtimeType == other.runtimeType &&
              sortType == other.sortType &&
              filterType == other.filterType &&
              pageNumber == other.pageNumber;

  @override
  int get hashCode =>
      sortType.hashCode ^ filterType.hashCode ^ pageNumber.hashCode;
}

class PageCache<PageQuery, Page> extends Cache {}

class PageRepository {
  final PubHtmlParsingClient client;
  final PageCache<PageQuery, Page> _pageCache = PageCache();

  PageRepository({@required this.client});

  Future<Page> get(PageQuery query) async {
    if (_pageCache.containsKey(query)) {
      return _pageCache[query];
    } else {
      Page page = await client.getPageOfPackages(
        pageNumber: query.pageNumber,
        sortBy: query.sortType,
        filterBy: query.filterType,
      );
      _pageCache.add(query, page);
      return page;
    }
  }
}
