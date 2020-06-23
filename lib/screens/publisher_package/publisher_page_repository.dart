import 'package:flutter/foundation.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/repository.dart';

/// Used as a data class for specifying details about queries in the PageClass
class PublisherPageQuery {
  final int pageNumber;
  final String publisherName;

  PublisherPageQuery({@required this.pageNumber, @required this.publisherName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublisherPageQuery &&
          runtimeType == other.runtimeType &&
          pageNumber == other.pageNumber &&
          publisherName == other.publisherName;

  @override
  int get hashCode => pageNumber.hashCode ^ publisherName.hashCode;
}

class PublisherPageRepository extends Repository<PublisherPageQuery, Page> {
  final PubHtmlParsingClient client;
  final PublisherPageCache _pageCache = PublisherPageCache.instance;

  PublisherPageRepository({@required this.client});

  Future<Page> get(PublisherPageQuery query) async {
    if (_pageCache.containsKey(query)) {
      return _pageCache[query];
    } else {
      Page page = await client.getPageOfPublisherPackages(
          pageNumber: query.pageNumber, publisherName: query.publisherName);
      _pageCache.add(query, page);
      return page;
    }
  }
}

class PublisherPageCache extends Cache<PublisherPageQuery, Page> {
  PublisherPageCache._() : super(shouldPersist: false);
  static final PublisherPageCache _instance = PublisherPageCache._();
  static PublisherPageCache get instance => _instance;
}
