import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pub_client/pub_client.dart';

class DefaultPackagesList extends StatelessWidget {
  final List<FullPackage> packagesFromPage;

  const DefaultPackagesList({Key key, this.packagesFromPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: packagesFromPage.length,
      itemBuilder: (context, index) {
        FullPackage package = packagesFromPage[index];
        return GroovinExpansionTile(
          title: Text(
            package.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            getSubTitle(package),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(package.description),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(children: [
                for (var compatibilityTag in package.compatibilityTags)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: RaisedButton.icon(
                      icon: Icon(GroovinMaterialIcons.tag),
                      label: Text(compatibilityTag),
                      disabledColor: Colors.blue[100],
                    ),
                  )
              ]),
            ),
            ListView.builder(
              itemCount: package.compatibilityTags.length,
              itemBuilder: (context, index) {
                return Text(
                  package.compatibilityTags[index].toString(),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ],
          trailing: CircleAvatar(
            child: package.score == null ? Text('?') : Text("${package.score}"),
          ),
        );
      },
    );
  }

  String getSubTitle(FullPackage package) {
    final DateFormat _dateFormat = DateFormat("MMM d, yyyy");
    return "v${package.latestVersion.major}."
        "${package.latestVersion.minor}.${package.latestVersion
        .patch}  updated "
        "${_dateFormat.format(package.dateModified)}";
  }
}
