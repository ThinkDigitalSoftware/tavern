import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/screens/publisher_package/publisher_event.dart';
import 'package:tavern/screens/publisher_package/publisher_page_repository.dart';
import 'package:tavern/screens/publisher_package/publisher_state.dart';
import 'package:tavern/src/enums.dart';

class PublisherBloc extends HydratedBloc<PublisherEvent, PublisherState> {
  final PubHtmlParsingClient client;
  final PublisherPageRepository _publisherPageRepository;

  @override
  PublisherState get initialState =>
      super.initialState ?? InitialPublisherState();

  PublisherBloc({@required this.client})
      : _publisherPageRepository = PublisherPageRepository(client: client);

  @override
  Stream<PublisherState> mapEventToState(PublisherEvent event) async* {
    if (event is GetPageOfPublisherPackagesEvent) {
      yield InitialPublisherState();
      final pageQuery = PublisherPageQuery(
        pageNumber: event.pageNumber,
        publisherName: event.publisherName,
      );

      Page page = await _publisherPageRepository.get(pageQuery);
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
      return initialState;
    }
  }

  @override
  Map<String, dynamic> toJson(PublisherState state) {
    try {
      return state.toJson();
    } on Exception {
      return initialState.toJson();
    }
  }

  static PublisherBloc of(BuildContext context) =>
      BlocProvider.of<PublisherBloc>(context);

  @override
  Future<void> close() {
    return super.close();
  }
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
