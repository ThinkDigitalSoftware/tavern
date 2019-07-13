import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:pub_dev_client/screens/package_details_page.dart';
import 'package:pub_dev_client/src/pub_colors.dart';

class PackageTile extends StatelessWidget {
  const PackageTile({
    Key key,
    @required this.page,
    this.index,
  }) : super(key: key);

  final Page page;
  final int index;

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (page.packages[index].score <= 50 ||
        page.packages[index].score == null) {
      scoreColor = Provider.of<PubColors>(context).badPackageScore;
    } else if (page.packages[index].score >= 51 &&
        page.packages[index].score <= 69) {
      scoreColor = Provider.of<PubColors>(context).goodPackageScore;
    } else {
      scoreColor = Provider.of<PubColors>(context).greatPackageScore;
    }

    final package = page.packages[index];

    final packageVersion = 'v${package.latest.semanticVersion.major}'
        '.${package.latest.semanticVersion.minor}'
        '.${package.latest.semanticVersion.patch}'
        ' updated ${package.dateUpdated}';

    return ListTile(
      title: Text(
        page.packages[index].name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(packageVersion),
      trailing: CircleAvatar(
          backgroundColor: scoreColor,
          child: Text(
            "${package.score ?? '--'}",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      onTap: () => Navigator.pushNamed(
        context,
        PackageDetailsPage.routeName,
        arguments: PackageDetailsArguments(
          page.packages[index].name,
          page.packages[index].score.toString(),
        ),
      ),
    );
  }
}
