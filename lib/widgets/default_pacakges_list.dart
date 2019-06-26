import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:pub_client/pub_client.dart';
import 'package:intl/intl.dart';

class DefaultPackagesList extends StatefulWidget {
  final List<FullPackage> packagesFromPage;

  const DefaultPackagesList({
    Key key,
    @required this.packagesFromPage,
  }) : super(key: key);

  @override
  _DefaultPackagesListState createState() => _DefaultPackagesListState();
}

class _DefaultPackagesListState extends State<DefaultPackagesList> {

  DateFormat _dateFormat = DateFormat("MMM d, yyyy");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.packagesFromPage.length,
      itemBuilder: (context, index) {
        return GroovinExpansionTile(
          title: Text(
            widget.packagesFromPage[index].name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "v " +
                widget.packagesFromPage[index].latestVersion.major.toString() +
                '.' +
                widget.packagesFromPage[index].latestVersion.minor.toString() +
                '.' +
                widget.packagesFromPage[index].latestVersion.patch.toString() +
                ' updated ' +
                _dateFormat.format(widget.packagesFromPage[index].dateModified),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(widget.packagesFromPage[index].description),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  ...widget.packagesFromPage[index].compatibilityTags.map<Widget>(
                        (t) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: RaisedButton.icon(
                            icon: Icon(GroovinMaterialIcons.tag),
                            label: Text(t),
                            disabledColor: Colors.blue[100],
                          ),
                        ),
                      ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: widget.packagesFromPage[index].compatibilityTags.length,
              itemBuilder: (context, index) {
                return Text(
                  widget.packagesFromPage[index].compatibilityTags[index].toString(),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ],
          trailing: CircleAvatar(
            child: widget.packagesFromPage[index].score == null
                ? Text('?')
                : Text(
                    widget.packagesFromPage[index].score.toString(),
                  ),
          ),
        );
      },
    );
  }
}
