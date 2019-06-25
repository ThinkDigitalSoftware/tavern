import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class HtmlView extends StatelessWidget {
  final String html;
  final String markdown;

  HtmlView({Key key, this.html})
      : this.markdown = html2md.convert(html),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var string =
    '''[![Go to the documentation of bloc 0.10.0](/static/img/ic_drive_document_black_24dp.svg)](/documentation/bloc/0.10.0/Go to the documentation of bloc 0.10.0) 

  [![Download bloc 0.10.0 archive](/static/img/ic_get_app_black_24dp.svg)](https://storage.googleapis.com/pub-packages/packages/bloc-0.10.0.tar.gzDownload bloc 0.10.0 archive) ''';
    string.splitMapJoin(RegExp(r'\(.*\)[^\)]'), onMatch: (match) {
      var matchText = match.group(0);

      if (!matchText.startsWith("(https://")) {
        print("fix this one");
        print(matchText);
      }
    });
    return Markdown(
      data: markdown,
    );
  }
}
