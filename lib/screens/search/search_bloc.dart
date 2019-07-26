import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/search/search_event.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PubHtmlParsingClient client;

  SearchRepository _searchRepository;

  SearchBloc({@required this.client}) {
    _searchRepository = SearchRepository(client: client);
  }

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is GetSearchResultsEvent) {
      List<Package> packages = await _searchRepository.get(event.query);
      yield SearchState(searchResults: packages);
    }
  }
}

class SearchCache<String, Search> extends Cache {}

class SearchRepository extends Repository<SearchQuery, List<Package>> {
  final PubHtmlParsingClient client;
  final SearchCache<SearchQuery, List<Package>> _searchCache = SearchCache();

  SearchRepository({@required this.client});

  Future<List<Package>> get(SearchQuery query) async {
    if (_searchCache.containsKey(query)) {
      return _searchCache[query];
    } else {
      List<Package> search = await client.search(
        query.query,
        sortBy: query.sortBy,
        filterBy: query.filterBy,
        isExactPhrase: query.isExactPhrase,
        isPrefix: query.isPrefix,
        isDependency: query.isDependency,
        isEmail: query.isEmail,
      );
      _searchCache.add(query, search);
      return search;
    }
  }
}

class SearchQuery {
  final String query;
  final SortType sortBy;
  final FilterType filterBy;
  final bool isExactPhrase;
  final bool isPrefix;
  final bool isDependency;
  final bool isEmail;

  SearchQuery(
    this.query, {
    this.sortBy = SortType.searchRelevance,
    this.filterBy = FilterType.all,
    this.isExactPhrase = false,
    this.isPrefix = false,
    this.isDependency = false,
    this.isEmail = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQuery &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          sortBy == other.sortBy &&
          filterBy == other.filterBy &&
          isExactPhrase == other.isExactPhrase &&
          isPrefix == other.isPrefix &&
          isDependency == other.isDependency &&
          isEmail == other.isEmail;

  @override
  int get hashCode =>
      query.hashCode ^
      sortBy.hashCode ^
      filterBy.hashCode ^
      isExactPhrase.hashCode ^
      isPrefix.hashCode ^
      isDependency.hashCode ^
      isEmail.hashCode;
}
