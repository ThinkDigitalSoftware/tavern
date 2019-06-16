import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart' hide Tab;
import 'package:pub_client/src/models.dart' as models;
import 'package:pub_dev_client/widgets/html_view.dart';

Future main() async {
  runApp(PubDevClientApp());
}

class PubDevClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xFF38bffc),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: Demo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 6);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<FullPackage>(
          future: PubHtmlParsingClient().get('bloc'),
          builder: (BuildContext context, AsyncSnapshot<FullPackage> snapshot) {
            if (!snapshot.hasData) return Container();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Material(
                  color: Colors.black,
                  child: TabBar(
                    isScrollable: true,
                    controller: controller,
                    tabs: <Widget>[
                      for (models.Tab tab in snapshot.data.tabs)
                        Tab(
                          text: tab.title,
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    children: <Widget>[
                      for (models.Tab tab in snapshot.data.tabs)
                        HtmlView(html: tab.content)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
