import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tavern/screens/bloc.dart';

@immutable
class SearchEvent {}

class GetSearchResultsEvent extends SearchEvent {
  final SearchQuery query;

  GetSearchResultsEvent({@required this.query});
}
