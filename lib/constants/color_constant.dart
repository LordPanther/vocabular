// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class COLOR_CONST {
  // Primary shades
  static const primaryColor = Color(0xFF3ac5c9);
  static final primaryOpaqueColor = const Color(0xFF3ac5c9).withOpacity(0.8);
  static const secondaryColor = Color(0xFF979797);
  static final secondaryOpaqueColor = const Color(0xFF979797).withOpacity(0.8);
  static const textColor = Color(0xFF4a4a4a);
  static const cardShadowColor = Color(0xFFd3d1d1);
  static const backgroundColor = Color(0xffF6F7FB);
  static const borderColor = Color(0xFFd3d1d1);

  static const accentTintColor = Color(0xFF7b60c4);
  static const accentShadeColor = Color(0xFF58458c);
  static const darkShadeColor = Color(0xFF25164d);
  static const dividerColor = Colors.black12;
  static const primaryGradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF25164d), Color.fromARGB(255, 255, 255, 255)],
  );

  ///Singleton factory
  static final COLOR_CONST _instance = COLOR_CONST._internal();

  factory COLOR_CONST() {
    return _instance;
  }

  COLOR_CONST._internal();
}

const mAnimationDuration = Duration(milliseconds: 200);
