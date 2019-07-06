import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:webfeed/domain/atom_feed.dart';
import 'package:webfeed/webfeed.dart';

class Feed {
  static final String _atomFeedUrl = "https://pub.dev/feed.atom";

  static Future<String> get _xmlString async {
    var result = await http.get(_atomFeedUrl);
    return result.body;
  }

  static Future<AtomFeed> get atomFeed async =>
      AtomFeed.parse(await _xmlString);

  static Future<List<FeedPackage>> get packages async {
    var _atomFeed = await atomFeed;
    List<FeedPackage> packages = [];
    for (final AtomItem item in _atomFeed.items) {
      packages.add(
        FeedPackage(
            title: item.title,
            dateUpdated: DateTime.parse(item.updated),
            authors: item.authors
                .map(
                  (atomPerson) => Author.fromAtomPerson(atomPerson),
                )
                .toList(),
            url: item.links.first.href,
            content: item.content),
      );
    }
    return packages;
  }
}

class FeedPackage {
  String title;
  DateTime dateUpdated;
  List<Author> authors;
  String url;
  String content;

  FeedPackage(
      {this.title, this.dateUpdated, this.authors, this.url, this.content});
}

class Author {
  String name;
  String email;

  Author({@required this.name, @required this.email});

  factory Author.fromAtomPerson(AtomPerson atomPerson) {
    var name = atomPerson.name;
    return Author(
      name: name.substring(0, name.indexOf('<')),
      email: name.substring(
        name.indexOf('<') + 1,
        name.indexOf('>'),
      ),
    );
  }
}
