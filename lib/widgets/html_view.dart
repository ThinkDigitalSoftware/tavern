import 'package:dynamic_theme/dynamic_theme.dart';
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
        super(key: key);

  static String parseHtml(String html) {
    return html2md.convert(html);
  }

  @override
  Widget build(BuildContext context) {
    // path to MarkdownStyleSheet.fromTheme: flutter_markdown/lib/src/style_sheet.dart
    final MarkdownStyleSheet defaultStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    final Color codeBackgroundColor =
        DynamicTheme.of(context).brightness == Brightness.light
            ? Colors.grey.shade300
            : Colors.grey.shade800;

    return Markdown(
      data: markdown,
      styleSheet: defaultStyleSheet.copyWith(
        code: defaultStyleSheet.code.copyWith(
          backgroundColor: codeBackgroundColor,
        ),
        codeblockDecoration: BoxDecoration(
          color: codeBackgroundColor,
          borderRadius: BorderRadius.circular(2.0),
        ),
        blockquote:
            Theme.of(context).textTheme.title.copyWith(color: Colors.grey),
        blockquoteDecoration: BoxDecoration(
          color: DynamicTheme.of(context).data.scaffoldBackgroundColor,
          border: Border(
            left: BorderSide(width: 3.0, color: Colors.grey),
          ),
        ),
        blockquotePadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
      ),
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
