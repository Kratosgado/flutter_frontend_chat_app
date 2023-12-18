import 'package:flutter/material.dart';

import 'font_manager.dart';

//  const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.white,
//             shadows: [Shadow(blurRadius: 2, offset: Offset(1, 1))],
//           ),

TextStyle _getTextStyle(double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
    shadows: const [Shadow(blurRadius: 2, offset: Offset(1, 1))],
  );
}

// regular style

TextStyle getRegularStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.regular, color);
}
// light text style

TextStyle getLightStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.light, color);
}
// bold text style

TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    FontWeightManager.bold,
    color,
  );
}

// semi bold text style

TextStyle getSemiBoldStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.semiBold, color);
}

// medium text style

TextStyle getMediumStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, FontWeightManager.medium, color);
}

class StyleManager {
  static final boxDecoration = BoxDecoration(
    // borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(color: Colors.blue, offset: Offset(0, -1), blurRadius: 5),
      BoxShadow(color: Colors.red, offset: Offset(0, 1), blurRadius: 5),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue.shade100,
        Colors.blue.shade900,
      ],
    ),
  );
}
