import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class HtmlView extends StatelessWidget {
  final String html;
  final String markdown;

  HtmlView({Key key, this.html})
      : markdown = html2md.convert(html),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdown,
    );
  }
}
