import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/screens/publisher_package/publisher_event.dart';
import 'package:tavern/screens/publisher_package/publisher_package.dart';
import 'package:tavern/screens/publisher_package/publisher_state.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/src/repository.dart';

class PublisherBloc extends HydratedBloc<PublisherEvent, PublisherState> {
  final PubHtmlParsingClient client;
  final String url;
  @override
  PublisherState get initialState =>
      super.initialState ?? InitialPublisherState(url);
  PageRepository _pageRepository;

  PublisherBloc({@required this.client, @required this.url}) {
    add(
      GetPageOfPublisherPackagesEvent(pageNumber: 1, publisherName: url),
    );
    _pageRepository = PageRepository(client: client);
  }

  @override
  Stream<PublisherState> mapEventToState(PublisherEvent event) async* {
    if (event is GetPageOfPublisherPackagesEvent) {
      Page page;
      final pageQuery = PageQuery(
        pageNumber: event.pageNumber,
        publisherName: event.publisherName,
      );
      page = await _pageRepository.get(pageQuery);
      yield state.copyWith(page: page, publisherName: event.publisherName);
      // for queries that need to be notified on the successful result.
      if (event.completer != null) {
        event.completer.complete(page);
      }
      return;
    }
    if (event is ChangeFilterEvent) {
      add(
        GetPageOfPublisherPackagesEvent(
          pageNumber: state.page.pageNumber,
        ),
      );
      return;
    }
    // if (event is ChangeBottomNavigationBarIndex) {
    //   yield state.copyWith(bottomNavigationBarIndex: event.index);
    //   return;
    // }
    if (event is ShowPackageDetailsEvent) {
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
  PublisherState fromJson(Map<String, dynamic> json) {
    try {
      return PublisherState.fromJson(json);
    } on Exception {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(PublisherState state) {
    try {
      return state.toJson();
    } on Exception {
      return null;
    }
  }

  static PublisherBloc of(BuildContext context) =>
      BlocProvider.of<PublisherBloc>(context);
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
  final int pageNumber;
  final String publisherName;
  PageQuery({@required this.pageNumber, @required this.publisherName});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageQuery &&
          runtimeType == other.runtimeType &&
          pageNumber == other.pageNumber;

  @override
  int get hashCode => pageNumber.hashCode;
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
      Page page = await client.getPageofPublisherPackages(
          pageNumber: query.pageNumber, publishername: query.publisherName);
      _pageCache.add(query, page);
      return page;
    }
  }
}
