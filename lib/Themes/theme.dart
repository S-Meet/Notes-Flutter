import 'package:flutter/material.dart';

Color greyShade = const Color(0xFF333333);
Color greyShade2 = const Color(0xFF181818);

ThemeData lightMode = ThemeData(

  brightness: Brightness.light,
  colorScheme: ColorScheme.light(

    background: Colors.white,
    primary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.grey,
  ),

);

ThemeData darkMode = ThemeData(

  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(

    background: Colors.black,
      primary: greyShade,
      secondary: greyShade2,
      onSecondary: Colors.grey,

  ),

);
