import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/package_details/package_details_screen.dart';
import 'package:tavern/src/enums.dart';
import 'package:tavern/src/pub_colors.dart';

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

    final packageVersion = 'v${package.latest.semanticVersion.major}'
        '.${package.latest.semanticVersion.minor}'
        '.${package.latest.semanticVersion.patch}'
        ' updated ${package.dateUpdated}';

    return ListTile(
      title: Text(
        packageName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(packageVersion),
      trailing: CircleAvatar(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? scoreColor
              : scoreColor.withAlpha(75),
          child: Text(
            "${package.score ?? '--'}",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      onTap: () async {
        return Navigator.pushNamed(
          context,
          Routes.packageDetailsScreen,
          arguments: PackageDetailsArguments(
            packageName,
            packageScore.toString(),
          ),
        );
      },
    );
  }
}
