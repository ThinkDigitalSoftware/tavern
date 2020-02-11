import 'package:flutter/material.dart';

class PubColors {
  static Color darkGunmetal = Color.fromRGBO(18, 32, 48, 1);
  static Color gunmetal = Color(0xFF30343F);
  static Color searchBarItemsColor = Colors.black45;
  static Color badPackageScore = Color.fromRGBO(187, 36, 0, 1);
  static Color goodPackageScore = Color.fromRGBO(0, 196, 179, 1);
  static Color greatPackageScore = Color.fromRGBO(1, 117, 194, 1);
  static Color turquoiseSurf = Colors.cyan;
  static Color ghostWhite = Color(0xFFFAFAFF);

  static ThemeData theme({
    @required Brightness brightness,
    @required BuildContext context,
  }) {
    bool isLightTheme = brightness == Brightness.light;

    return ThemeData(
      indicatorColor: PubColors.turquoiseSurf,
      iconTheme: IconThemeData(
        color: isLightTheme ? Color(0xFF004A54) : PubColors.ghostWhite,
      ),
      fontFamily: 'Metropolis',
      accentColor: PubColors.turquoiseSurf,
      primaryColorDark: PubColors.darkGunmetal,
      scaffoldBackgroundColor:
          isLightTheme ? PubColors.ghostWhite : PubColors.darkGunmetal,
      brightness: brightness,
      primarySwatch: PubColors.turquoiseSurf,
      primaryColorBrightness: brightness,
      cardColor: isLightTheme ? null : ThemeData.dark().cardColor,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            brightness: brightness,
            color: isLightTheme ? PubColors.ghostWhite : PubColors.darkGunmetal,
          ),
      sliderTheme: SliderThemeData(
        disabledActiveTrackColor: PubColors.turquoiseSurf,
        disabledActiveTickMarkColor: PubColors.turquoiseSurf,
      ),
    );
  }
}
