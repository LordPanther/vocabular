import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomCardWidget({
    super.key,
    this.decoration,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: height,
          margin: margin ??
              EdgeInsets.symmetric(
                vertical: SizeConfig.defaultSize * 0.5,
                horizontal: SizeConfig.defaultSize * 1.5,
              ),
          padding: padding ?? EdgeInsets.all(SizeConfig.defaultPadding),
          decoration: decoration ?? _defaultDecoration(),
          child: child,
        ),
      ),
    );
  }

  _defaultDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: COLOR_CONST.borderColor.withOpacity(0.3)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          blurRadius: 1,
          spreadRadius: 1,
          color: COLOR_CONST.cardShadowColor.withOpacity(0.2),
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
