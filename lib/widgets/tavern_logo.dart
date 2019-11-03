part of 'widgets.dart';

class TavernAnimatedLogo extends StatefulWidget {
  const TavernAnimatedLogo({
    Key key,
  }) : super(key: key);

  @override
  _TavernAnimatedLogoState createState() => _TavernAnimatedLogoState();
}

class _TavernAnimatedLogoState extends State<TavernAnimatedLogo>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
                "Tavern",
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
