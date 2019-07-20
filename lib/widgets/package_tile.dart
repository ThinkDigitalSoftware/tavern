import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_page.dart';
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
    if (packageScore <= 50 || packageScore == null) {
      scoreColor = Provider.of<PubColors>(context).badPackageScore;
    } else if (packageScore >= 51 && packageScore <= 69) {
      scoreColor = Provider.of<PubColors>(context).goodPackageScore;
    } else {
      scoreColor = Provider.of<PubColors>(context).greatPackageScore;
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
          backgroundColor: scoreColor,
          child: Text(
            "${package.score ?? '--'}",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      onTap: () async {
        final getPackageDetailsEvent = GetPackageDetailsEvent(
            packageName: packageName, packageScore: packageScore);
        BlocProvider.of<PackageDetailsBloc>(context)
          ..dispatch(Initialize())..dispatch(getPackageDetailsEvent);
        return Navigator.pushNamed(
          context,
          PackageDetailsPage.routeName,
          arguments: PackageDetailsArguments(
            packageName,
            packageScore.toString(),
          ),
        );
      },
    );
  }
}
