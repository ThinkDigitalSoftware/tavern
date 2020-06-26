import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide showSearch;
import 'package:google_fonts/google_fonts.dart';
import 'package:tavern/screens/publisher_package/publisher_page_repository.dart';
import 'package:tavern/screens/publisher_package/publisher_state.dart';
import 'package:tavern/widgets/publisher_list_view.dart';

class PublisherPackagesPage extends StatelessWidget {
  final String publisher;
  final PublisherState publisherState;

  const PublisherPackagesPage({
    Key key,
    @required this.publisher,
    this.publisherState,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final double expandedHeight = 200;
    final double bottomHeight = 40;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: PageView(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 3,
                  forceElevated: true,
                  backgroundColor:
                      DynamicTheme.of(context).data.appBarTheme.color,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  snap: true,
                  floating: true,
                  title: headerTextWidget(publisher),
//                  expandedHeight: expandedHeight,
//TODO: Add publisher's description here.
//                  bottom: PreferredSize(
//                    preferredSize:
//                        Size(MediaQuery.of(context).size.width, bottomHeight),
//                    child: Text('Future home of description section'),
//                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 10),
                ),
                if (publisherState is! InitialPublisherState)
                  PublisherListView(
                    pageQuery: PublisherPageQuery(
                      pageNumber: publisherState.page.pageNumber,
                      publisherName: publisher,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 20,
                            child: LinearProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget headerTextWidget(String publisher) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          child: AutoSizeText(
            'Packages by $publisher',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 22,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            minFontSize: 2,
            maxFontSize: 30,
            wrapWords: true,
            softWrap: true,
          ),
        );
      },
    );
  }
}
