/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/03/2022

// Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// The class that holds data related to the theme of the app
class AppTheme {
  // Static final variables that can be accessed from anywhere
  // in the app when needed
  static final MaterialColor _mainColour =
      MaterialColor(0xFFcd3d32, _mainColourSwatch);

  static final Map<int, Color> _mainColourSwatch = {
    50: const Color.fromRGBO(205, 61, 50, .1),
    100: const Color.fromRGBO(205, 61, 50, .2),
    200: const Color.fromRGBO(205, 61, 50, .3),
    300: const Color.fromRGBO(205, 61, 50, .4),
    400: const Color.fromRGBO(205, 61, 50, .5),
    500: const Color.fromRGBO(205, 61, 50, .6),
    600: const Color.fromRGBO(205, 61, 50, .7),
    700: const Color.fromRGBO(205, 61, 50, .8),
    800: const Color.fromRGBO(205, 61, 50, .9),
    900: const Color.fromRGBO(205, 61, 50, 1),
  };

  static final ThemeData appTheme = ThemeData(
    primarySwatch: _mainColour,
  );
}
