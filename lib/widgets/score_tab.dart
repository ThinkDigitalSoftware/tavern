part of 'widgets.dart';

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
