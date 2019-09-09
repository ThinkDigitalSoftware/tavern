import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';

import 'html_view.dart';

class ScoreTab extends StatelessWidget {
  final FullPackage package;

  const ScoreTab({Key key, this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(
            html: package.packageTabs[4].content,
          ),
        ),
      ],
    );
  }
}
