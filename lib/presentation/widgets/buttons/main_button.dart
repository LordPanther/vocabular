import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';

class MainButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color backgroundColor;
  final double? borderRadius;

  const MainButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = COLOR_CONST.cardShadowColor,
    this.borderRadius,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.defaultSize * 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ??
            0.0), // Use provided border radius or default to 0.0
        color: backgroundColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(backgroundColor: backgroundColor),
        child: child,
      ),
    );
  }
}
