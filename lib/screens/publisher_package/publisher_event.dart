import 'dart:async';

import 'package:flutter/cupertino.dart' hide Page;
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class PublisherEvent {
  final StackTrace _stackTrace = StackTrace.current;
}

class GetPageOfPublisherPackagesEvent extends PublisherEvent {
  final int pageNumber;
  final String publisherName;
  final Completer<Page> completer;

  GetPageOfPublisherPackagesEvent({
    this.pageNumber = 1,
    this.completer,
    this.publisherName,
  });

  GetPageOfPublisherPackagesEvent copyWith({
    int pageNumber,
    String publisherName,
  }) {
    return GetPageOfPublisherPackagesEvent(
      pageNumber: pageNumber ?? this.pageNumber,
      publisherName: publisherName ?? this.publisherName,
    );
  }
}

class ChangeFilterEvent extends PublisherEvent {
  final FilterType filterType;

  ChangeFilterEvent({@required this.filterType});
}

class ChangeBottomNavigationBarIndex extends PublisherEvent {
  final int index;

  ChangeBottomNavigationBarIndex(this.index);
}

class ShowPackageDetailsEvent extends PublisherEvent {
  final BuildContext context;
  final Package package;

  ShowPackageDetailsEvent({@required this.context, @required this.package})
      : assert(context != null),
        assert(package != null);
}
