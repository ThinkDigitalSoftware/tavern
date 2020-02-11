import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String headline;
  final Widget content;
  final EdgeInsets margin;

  const Section({
    Key key,
    @required this.headline,
    @required this.content,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeadlineText(headline),
          content,
        ],
      ),
    );
  }
}

class HeadlineText extends StatelessWidget {
  final String data;

  const HeadlineText(
    this.data, {
    Key key,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        data,
        style: Theme.of(context).textTheme.headline.copyWith(fontSize: 30),
//        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 30),
      ),
    );
  }
}
