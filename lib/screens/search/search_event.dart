import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tavern/screens/bloc.dart';

@immutable
class SearchEvent {}

class ResetSearchEvent extends SearchEvent {}

class GetSearchResultsEvent extends SearchEvent {
  final SearchQuery query;

  GetSearchResultsEvent({@required this.query});
}

class GetSearchHistoryEvent extends SearchEvent {
  final List<String> searchHistory;

  GetSearchHistoryEvent({@required this.searchHistory});
}
