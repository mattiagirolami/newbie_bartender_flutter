import 'package:flutter/material.dart';

class ColorsPersonal {
  static const Color arancione_bello = Color(0xFFFA7E0A);
  static const Color arancione_sfondo = Color(0xFFFFC085);
  static const Color verde_button = Color(0xFF66B229);
  static const Color grigio_batman = Color(0xB2FFFFFF);

  static MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}