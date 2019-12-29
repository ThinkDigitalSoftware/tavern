import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/src/pub_colors.dart';
import 'package:url_launcher/url_launcher.dart';

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

    String packageVersionString;
    if (package.latest != null) {
      packageVersionString = 'v${package.latest.semanticVersion.major}'
          '.${package.latest.semanticVersion.minor}'
          '.${package.latest.semanticVersion.patch}'
          '${package.dateUpdated != null ? ' updated ${package.dateUpdated}' : ''}';
    } else {
      packageVersionString = "";
    }

    bool hasPackageTag(String tag) =>
        package.platformCompatibilityTags.contains(tag.toLowerCase());
    return ListTile(
      title: Text(
        packageName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("\n$packageVersionString"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (String tag in platformCompatibilityTags)
                if (hasPackageTag(tag))
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                      backgroundColor: Colors.transparent,
                      label: Text(
                        tag,
                      ),
                      labelStyle:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
            ],
          )
        ],
      ),
      trailing: packageScore != null
          ? CircleAvatar(
              backgroundColor: Theme.of(context).brightness == Brightness.light
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
          launch(package.packageUrl, forceSafariVC: true, forceWebView: true);
        } else {
          HomeBloc.of(context).add(
            ShowPackageDetailsPageEvent(context: context, package: package),
          );
        }
      },
    );
  }
}

const List<String> platformCompatibilityTags = [
  'FLUTTER',
  'ANDROID',
  'IOS',
  'WEB',
  'DART',
  'NATIVE',
  'JS'
];
