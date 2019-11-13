import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/widgets/material_search.dart';
import 'package:tavern/widgets/package_tile.dart';

class PubSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  PubSearchDelegate({@required this.searchBloc});

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(
      GetSearchResultsEvent(
        query: SearchQuery(query),
      ),
    );
    return Material(
      child:
          BlocBuilder<SearchBloc, SearchState>(builder: (context, searchState) {
        if (searchState is! SearchCompleteState) {
          return Center(child: CircularProgressIndicator());
        } else {
          final packages = (searchState as SearchCompleteState).searchResults;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              Package package = packages[index];
              return PackageTile(package: package);
            },
          );
        }
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, searchState) {
        final filteredSearchHistory = searchBloc.searchHistory
            .where((history) => history.contains(query))
            .toList();
        return ListView.builder(
          itemCount: filteredSearchHistory.length,
          itemBuilder: (BuildContext context, int index) {
            var suggestionText = filteredSearchHistory[index];
            return ListTile(
              title: Text(suggestionText),
              onTap: () {
                query = suggestionText;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSearchBar({
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    TextInputAction textInputAction,
    Function(String) onSubmitted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 16,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
//                    focusNode: focusNode,
                  autofocus: true,
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Dart packages',
                    icon: IconButton(
                      padding: EdgeInsets.only(left: 8),
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () => showResults(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    Key key,
    @required this.package,
  }) : super(key: key);

  final Package package;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        title: Text(package.name),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.packageDetailsScreen,
          arguments: PackageDetailsArguments(
            package.name,
          ),
        ),
      ),
    );
  }
}
