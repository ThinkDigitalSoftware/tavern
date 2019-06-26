import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pub_client/pub_client.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pub_dev_client/widgets/pub_header.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PubClient _client = PubClient();
  PubHtmlParsingClient _htmlParsingClient = PubHtmlParsingClient();
  Page firstPage;
  int FIRST_PAGE = 1;
  List<FullPackage> packagesFromPage = [];
  DateFormat _dateFormat = DateFormat("MMM d, yyyy");

  /// Takes a Page of Packages and gets the FullPackage
  /// equivalents of each Package
  void convertToFullPackagesFromPage(Page page) async {
    for (int i = 0; i < page.packages.length; i++) {
      String packageName = page.packages[i].name;
      try {
        FullPackage _fullPackage = await _htmlParsingClient.get(packageName);
        packagesFromPage.add(_fullPackage);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF122030),
        title: Image.asset('images/dart-packages-white.png'),
      ),
      body: FutureBuilder<Page>(
        future: _client.getPageOfPackages(1),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final page = snapshot.data;
            convertToFullPackagesFromPage(page);
            print(packagesFromPage.length);
            return Column(
              children: <Widget>[
                NestedScrollView(
                  headerSliverBuilder: (context, innerBoxScrolled) {
                    return <Widget>[
                      PubHeader(),
                    ];
                  },
                  body: ListView.builder(
                    itemCount: packagesFromPage.length,
                    itemBuilder: (context, index) {
                      return GroovinExpansionTile(
                        title: Text(
                          packagesFromPage[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "v " +
                          packagesFromPage[index].latestVersion.major.toString() +
                          '.' +
                          packagesFromPage[index].latestVersion.minor.toString() +
                          '.' +
                          packagesFromPage[index].latestVersion.patch.toString() +
                          ' updated ' +
                          _dateFormat.format(packagesFromPage[index].dateModified),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Text(packagesFromPage[index].description),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                ...packagesFromPage[index].compatibilityTags.map<Widget>((t) =>
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: RaisedButton.icon(
                                        icon: Icon(GroovinMaterialIcons.tag),
                                        label: Text(t),
                                        disabledColor: Colors.blue[100],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            itemCount: packagesFromPage[index].compatibilityTags.length,
                            itemBuilder: (context, index) {
                              return Text(
                                  packagesFromPage[index].compatibilityTags[index].toString());
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ],
                        trailing: CircleAvatar(
                          child: packagesFromPage[index].score == null
                              ? Text('?')
                              : Text(packagesFromPage[index].score.toString()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
