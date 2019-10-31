import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlView extends StatelessWidget {
  final String html;
  final String markdown;

  HtmlView({Key key, this.html})
      : markdown = parseHtml(html),
        //.replaceAll(RegExp(r'\[#\]\(.*\)'), '\n'),
        super(key: key);

  static String parseHtml(String html) {
    return html2md.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdown,
      onTapLink: (String link) {
        final prefix = 'https://pub.dev/packages/';
        if (link.startsWith(prefix)) {
          final suffix = link.substring(link.lastIndexOf('/') + 1);
          HomeBloc.of(context).add(
            ShowPackageDetailsPageEvent(
              context: context,
              package: Package(name: suffix, score: 0),
            ),
          );
        } else {
          launch(link);
        }
      },
      imageBuilder: (uri) {
        if (uri.toString().contains('.svg')) {
          return SvgPicture.network(
            uri.toString(),
          );
        } else {
          return Image.network(uri.toString());
        }
      },
    );
  }
}

////! Doesn't currently work without throwing errors.
//class DartSyntaxHighlighter extends SyntaxHighlighter {
//  final _dartSyntaxHighlighter = dartSyntaxHighlighter.DartSyntaxHighlighter();
//
//  @override
//  TextSpan format(String source) => _dartSyntaxHighlighter.format(source);
//}
