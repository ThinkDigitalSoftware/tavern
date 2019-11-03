part of 'widgets.dart';

class PackageTile extends StatelessWidget {
  const PackageTile({
    Key key,
    @required this.package,
  }) : super(key: key);

  final Package package;

  int get packageScore => package.score;

  String get packageName => package.name;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Color scoreColor;
      if (packageScore != null) {
        if (packageScore <= 50) {
          scoreColor = PubColors.badPackageScore;
        } else if (packageScore >= 51 && packageScore <= 69) {
          scoreColor = PubColors.goodPackageScore;
        } else {
          scoreColor = PubColors.greatPackageScore;
        }
      }

      final packageVersion = '${package.latest.semanticVersion}\n'
          '${package.dateUpdated != null ? 'Updated ${package.dateUpdated}' : ''}';

      return Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                packageName,
                style: Theme.of(context)
                    .primaryTextTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                packageVersion,
              )
            ],
          ),
          trailing: packageScore != null
              ? CircleAvatar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? scoreColor
                          : scoreColor.withAlpha(75),
                  child: Text(
                    "${package.score}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
          onTap: () {
            if (package.name.startsWith('dart:')) {
              launch(package.packageUrl,
                  forceSafariVC: true, forceWebView: true);
            } else {
              HomeBloc.of(context).add(
                ShowPackageDetailsPageEvent(context: context, package: package),
              );
            }
          },
        ),
      );
    });
  }
}
