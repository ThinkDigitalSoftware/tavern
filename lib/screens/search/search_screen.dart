import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/screens/search/search_qualifiers.dart';
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
        query: SearchQuery(
          query,
        ),
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
          child: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              border: InputBorder.none,
              hintText: 'Search packages',
              icon: IconButton(
                padding: EdgeInsets.only(left: 8),
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              suffixIcon: Container(
                padding: EdgeInsets.only(right: 15),
                child: PopupMenuButton<SearchQualifier>(
                  offset: Offset(0, -20),
                  initialValue: SearchQualifier.none,
                  icon: Icon(Icons.search,
                      color: DynamicTheme.of(context).data.iconTheme.color),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: SearchQualifier.none,
                      child: Text('None'),
                    ),
                    PopupMenuItem(
                      value: SearchQualifier.exactPhrase,
                      child: Text('Exact Phrase'),
                    ),
                    PopupMenuItem(
                      value: SearchQualifier.dependency,
                      child: Text('Search Dependencies'),
                    ),
                    PopupMenuItem(
                      value: SearchQualifier.email,
                      child: Text('Search by Email'),
                    ),
                    PopupMenuItem(
                      value: SearchQualifier.prefix,
                      child: Tooltip(
                          message:
                              "Searches for packages that begin with prefix. Use this feature to find packages in the same framework",
                          child: Text('Search by prefix')),
                    ),
                  ],
                  onSelected: (searchQualifier) => SearchBloc.of(context)
                      .add(SetSearchQualifierEvent(searchQualifier)),
                ),
              ),
            ),
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
            package,
          ),
        ),
      ),
    );
  }
}
