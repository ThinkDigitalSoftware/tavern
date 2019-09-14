import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';

import 'html_view.dart';

class AnalysisTab extends StatelessWidget {
  final AnalysisPackageTab packageTab;

  const AnalysisTab({Key key, this.packageTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: HtmlView(
            html: packageTab.content,
          ),
        ),
      ],
    );
  }
}
