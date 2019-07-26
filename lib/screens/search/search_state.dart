import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class SearchState {
  final List<Package> searchResults;

  const SearchState({@required this.searchResults});
}

class InitialSearchState extends SearchState {}
