import 'package:flutter/material.dart';

class PubDevAnimatedLogo extends StatelessWidget {
  const PubDevAnimatedLogo({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
            offset: Offset(0, animationController.value * 25),
            child: Opacity(
              opacity: animationController.value,
              child: Text(
                "Pub.dev",
                style: TextStyle(fontSize: 45),
              ),
            ),
          );
        },
        animation: animationController,
      ),
    );
  }
}
