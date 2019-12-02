import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/search/search_qualifiers.dart';

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

class SetSearchQualifierEvent extends SearchEvent {
  final SearchQualifier searchQualifier;

  SetSearchQualifierEvent(this.searchQualifier);
}
