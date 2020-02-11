import 'dart:async';

import 'package:autotrie/autotrie.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/search/search_event.dart';
import 'package:tavern/screens/search/search_qualifiers.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PubHtmlParsingClient client;

  final SearchRepository _searchRepository;

  List<String> get searchHistory => _searchRepository.searchHistory;

  SearchBloc({@required this.client})
      : _searchRepository = SearchRepository(client: client);

  @override
  SearchState get initialState =>
      InitialSearchState(searchHistory: _searchRepository.searchHistory);

  static SearchBloc of(BuildContext context) =>
      BlocProvider.of<SearchBloc>(context);

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is GetSearchResultsEvent) {
      yield SearchLoadingState(searchHistory: state.searchHistory);
      List<Package> packages = await _searchRepository.get(event.query);
      yield SearchCompleteState(searchResults: packages);
    } else if (event is GetSearchHistoryEvent) {
      yield state.copyWith(searchHistory: _searchRepository.searchHistory);
    } else if (event is ResetSearchEvent) {
      yield initialState;
    } else if (event is SetSearchQualifierEvent) {
      yield state.copyWith(searchQualifier: event.searchQualifier);
    }
  }
}

class SearchCache extends Cache<SearchQuery, List<Package>> {
  List<String> searchHistory;
  AutoComplete engine;

  SearchCache()
      : super(
          shouldPersist: false,
          keyToString: (searchQuery) => searchQuery.toString(),
          valueToJsonEncodable: (packages) =>
              [for (final package in packages) package.toJson()],
          valueFromJsonEncodable: (json) =>
              [for (final packageJson in json) Package.fromJson(packageJson)],
        ) {
    getIt.registerSingleton<SearchCache>(this);
    initialize();
  }

  @override
  Future initialize() async {
    await super.initialize();
    searchHistory = box.get('searchHistory') ?? [];
//    engine = AutoComplete(bank: searchHistory);
  }

  @override
  void add(SearchQuery key, List<Package> value) {
    searchHistory.add(key.query);
    box.put('searchHistory', searchHistory);
    super.add(key, value);
  }
}

class SearchRepository extends Repository<SearchQuery, List<Package>> {
  final PubHtmlParsingClient client;
  final SearchCache _searchCache = SearchCache();
  Box searchBox;

  SearchRepository({@required this.client});

  Future<List<Package>> get(SearchQuery query) async {
    if (_searchCache.containsKey(query)) {
      return _searchCache[query];
    } else {
      List<Package> search = await client.search(
        query.query,
        sortBy: query.sortBy,
        filterBy: query.filterBy,
        isExactPhrase: query.searchQualifier == SearchQualifier.exactPhrase,
        isPrefix: query.searchQualifier == SearchQualifier.prefix,
        isDependency: query.searchQualifier == SearchQualifier.dependency,
        isEmail: query.searchQualifier == SearchQualifier.email,
      );
      _searchCache.add(query, search);
      return search;
    }
  }

  List<String> get searchHistory => _searchCache.searchHistory;
}

class SearchQuery {
  final String query;
  final SortType sortBy;
  final FilterType filterBy;
  final SearchQualifier searchQualifier;

  SearchQuery(
    this.query, {
    this.sortBy = SortType.searchRelevance,
    this.filterBy = FilterType.all,
    this.searchQualifier = SearchQualifier.none,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQuery &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          sortBy == other.sortBy &&
          filterBy == other.filterBy &&
          searchQualifier == other.searchQualifier;

  @override
  int get hashCode =>
      query.hashCode ^
      sortBy.hashCode ^
      filterBy.hashCode ^
      searchQualifier.hashCode;
}
