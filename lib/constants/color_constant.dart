// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class COLOR_CONST {
  // Primary shades
  static const primaryColor = Color(0xFF3ac5c9);
  static const secondaryColor = Color.fromRGBO(151, 151, 151, 1);
  static const textColor = Color(0xFF4a4a4a);
  static const darkTextColor = Color(0xFF4a4a4a);
  static const cardShadowColor = Color(0xFFd3d1d1);
  static const darkCardShadowColor = Color(0xFFd3d1d1);
  static const backgroundColor = Color(0xffF6F7FB);
  static const darkBackgroundColor = Color(0xFF121212);
  static const activeColor = Color(0xFFF05959);
  static const dividerColor = Color(0x1F000000);

  static const grey = Color(0xFFC0C0C0);
  static const turquoise = Color(0xFF40E0D0);
  static const mediumTurquoise = Color(0xFF48D1CC);
  static const darkTurquoise = Color(0xFF00CED1);
  static const lightSeaGreen = Color(0xFF20B2AA);

  ///Singleton factory
  static final COLOR_CONST _instance = COLOR_CONST._internal();

  factory COLOR_CONST() {
    return _instance;
  }

  COLOR_CONST._internal();
}

const mAnimationDuration = Duration(milliseconds: 200);
