import 'package:flutter/material.dart';

class Tools {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color wtmBlueColor = Tools.hexToColor("#4285f4");
  static Color wtmBlueLight = Tools.hexToColor("#4dcfff");
  static Color wtmGreen = Tools.hexToColor("#00bea4");
  static Color wtmGreenLight = Tools.hexToColor("#1ae9b6");
  static Color french = Colors.blueAccent;
  static Color english = Tools.hexToColor("#FF0000");

  static Color getColorForLanguage(String language) {
    if (language.toLowerCase() =="english" || language.toLowerCase() == "anglais") {
      return english;
    } else {
      return french;
    }
  }
  static List<Color> multiColors = [
    wtmBlueColor,
    wtmBlueLight,
    wtmGreen,
    wtmGreenLight,
  ];
}
