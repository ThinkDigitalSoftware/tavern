import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/widgets/material_search.dart';

class SearchScreen extends StatelessWidget {
  final SearchState searchState;

  const SearchScreen({Key key, @required this.searchState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Hero(
                tag: 'SearchBar',
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
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Search Dart packages',
                              icon: IconButton(
                                padding: EdgeInsets.only(left: 8),
                                icon: Icon(
                                  Icons.arrow_back,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PubSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  PubSearchDelegate({@required this.searchBloc});

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text('No Search Results'),
      );
    } else {
      return BlocBuilder<SearchBloc, SearchState>(
          builder: (context, searchState) {
            if (searchState.searchResults == null) {
              return Center(child: CircularProgressIndicator());
            }
            final packages = searchState.searchResults;
            return ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Theme
                      .of(context)
                      .canvasColor,
                  child: ListTile(
                    title: Text(packages[index].name),
                    onTap: () =>
                        Navigator.pushNamed(
                          context,
                          Routes.packageDetailsScreen,
                          arguments: PackageDetailsArguments(
                            packages[index].name,
                            packages[index].score.toString(),
                          ),
                        ),
                  ),
                );
              },
            );
          });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text('No Search Results'),
      );
    } else {
      searchBloc.dispatch(
        GetSearchResultsEvent(
          query: SearchQuery(query),
        ),
      );
      return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, searchState) {
          final List<Package> packages = searchState.searchResults;
          if (searchState is InitialSearchState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              return SuggestionTile(package: packages[index]);
            },
          );
        },
      );
    }
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
      child: Hero(
        tag: 'SearchBar',
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
                    focusNode: focusNode,
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
      ),
    );
  }
}

class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    Key key,
    @required this.package,
  }) : super(key: key);

  final Package package;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme
          .of(context)
          .canvasColor,
      child: ListTile(
        title: Text(package.name),
        onTap: () =>
            Navigator.pushNamed(
              context,
              Routes.packageDetailsScreen,
              arguments: PackageDetailsArguments(
                package.name,
                package.score.toString(),
              ),
            ),
      ),
    );
  }
}
