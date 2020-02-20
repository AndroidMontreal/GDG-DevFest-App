import 'package:flutter/material.dart';

class Tools {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color wtmBlueColor = Tools.hexToColor("#4285f4");
  static List<Color> multiColors = [
    Colors.red,
    Colors.amber,
    Colors.green,
    Colors.blue,
  ];
}
