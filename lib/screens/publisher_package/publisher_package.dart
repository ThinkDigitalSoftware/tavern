import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide showSearch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/publisher_package/publisher_bloc.dart';
import 'package:tavern/screens/publisher_package/publisher_state.dart';
import 'package:tavern/widgets/publisher_list_view.dart';
import 'package:tavern/widgets/search_bar.dart';
import 'package:tavern/widgets/tavern_logo.dart';

class PublisherPackakge extends StatefulWidget {
//final _PublisherPackakgeState homeState;
  final String publisher;
  final PublisherState publisherState;
  const PublisherPackakge(
      {Key key, @required this.publisher, this.publisherState})
      : super(key: key);
  @override
  _PublisherPackakgeState createState() => _PublisherPackakgeState();
}

class _PublisherPackakgeState extends State<PublisherPackakge>
    with TickerProviderStateMixin {
  double fontRatio;
  bool showAnimation = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double expandedHeight = 200;
    final double bottomHeight = 40;
    //HomeBloc _homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: showLogo
          ? TavernAnimatedLogo()
          : SafeArea(
              child: Padding(
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
                          expandedHeight: expandedHeight,
                          title: headerTextWidget(widget.publisher),
                          bottom: PreferredSize(
                            preferredSize: Size(
                                MediaQuery.of(context).size.width,
                                bottomHeight),
                            child: Text(''),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        PublisherListView(
                          pageQuery: PageQuery(
                              pageNumber: widget.publisherState.page.pageNumber,
                              publisherName: widget.publisher),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool get showLogo =>
      widget.publisherState is InitialPublisherState || showAnimation;
  Widget headerTextWidget(String publisher) {
    return AutoSizeText(
      'Packages by $publisher',
      //minFontSize: fontRatio.ceilToDouble(),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
