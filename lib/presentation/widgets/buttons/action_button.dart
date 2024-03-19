import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';

class ActionButton extends StatelessWidget {
  final Function() onPressed;
  final Color buttonColor;
  final String text;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.defaultSize * 20,
      height: SizeConfig.defaultSize * 6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(color: COLOR_CONST.backgroundColor)),
      ),
    );
  }
}
