import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/src/repository.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final PubHtmlParsingClient client;

  @override
  HomeState get initialState => super.initialState ?? InitialHomeState();
  PageRepository _pageRepository;

  HomeBloc({@required this.client}) {
    add(
      GetPageOfPackagesEvent(
        pageNumber: 1,
        sortBy: state.sortType,
        filterBy: state.filterType,
      ),
    );
    _pageRepository = PageRepository(client: client);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetPageOfPackagesEvent) {
      Page page;
      final pageQuery = PageQuery(
        sortType: event.sortBy,
        filterType: event.filterBy,
        pageNumber: event.pageNumber,
      );
      page = await _pageRepository.get(pageQuery);
      yield state.copyWith(
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
      add(
        GetPageOfPackagesEvent(
          pageNumber: state.page.pageNumber,
          sortBy: state.sortType,
          filterBy: event.filterType,
        ),
      );
      return;
    }
    if (event is ChangeBottomNavigationBarIndex) {
      yield state.copyWith(bottomNavigationBarIndex: event.index);
      return;
    }
    if (event is ShowPackageDetailsPageEvent) {
      Navigator.pushNamed(
        event.context,
        Routes.packageDetailsScreen,
        arguments: PackageDetailsArguments(
          event.package,
        ),
      );
    }
  }

  @override
  HomeState fromJson(Map<String, dynamic> json) {
    try {
      return HomeState.fromJson(json);
    } on Exception {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(HomeState state) {
    try {
      return state.toJson();
    } on Exception {
      return null;
    }
  }

  static HomeBloc of(BuildContext context) =>
      BlocProvider.of<HomeBloc>(context);
}

class HomePreferences {
  final SortType sortType;
  final FilterType filterType;

  HomePreferences({
    @required this.sortType,
    @required this.filterType,
  })  : assert(sortType != null, "sortType cannot be null."),
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
  })  : assert(sortType != null, "sortType cannot be null."),
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

class PageCache extends Cache<PageQuery, Page> {
  PageCache() : super(shouldPersist: false) {
    getIt.registerSingleton(this);
  }
}

class PageRepository extends Repository<PageQuery, Page> {
  final PubHtmlParsingClient client;
  final PageCache _pageCache = PageCache();

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
