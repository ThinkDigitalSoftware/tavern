import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:pub_client/pub_client.dart';

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
    return GroovinExpansionTile(
      title: Text(
        page.packages[index].name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'v ' +
            page.packages[index].latest.version.major.toString() +
            '.' +
            page.packages[index].latest.version.minor.toString() +
            '.' +
            page.packages[index].latest.version.patch.toString() +
            ' updated ' +
            page.packages[index].dateUpdated,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(page.packages[index].description),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Row(
            children: <Widget>[
              ...page.packages[index].packageTags.map<Widget>(
                    (tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 30,
                    width: 86,
                    color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(GroovinMaterialIcons.tag, size: 16, color: Colors.black38,),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            tag,
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      trailing: CircleAvatar(
        child: page.packages[index].score == null
            ? Text('?')
            : Text(
          page.packages[index].score.toString(),
        ),
      ),
    );
  }
}