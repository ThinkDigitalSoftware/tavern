import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:syntax_highlighter/syntax_highlighter.dart'
    as dartSyntaxHighlighter;
import 'package:url_launcher/url_launcher.dart';

class HtmlView extends StatelessWidget {
  final String html;
  final String markdown;

  HtmlView({Key key, this.html})
      : markdown = parseHtml(html),
        //.replaceAll(RegExp(r'\[#\]\(.*\)'), '\n'),
        super(key: key);

  static String parseHtml(String html) {
    Document document = parse(html);
//    document.getElementsByClassName("classNames");
    return html2md.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdown,
      onTapLink: (String link) {
        launch(link);
      },
    );
  }
}

//! Doesn't currently work without throwing errors.
class DartSyntaxHighlighter extends SyntaxHighlighter {
  final _dartSyntaxHighlighter = dartSyntaxHighlighter.DartSyntaxHighlighter();

  @override
  TextSpan format(String source) => _dartSyntaxHighlighter.format(source);
}
