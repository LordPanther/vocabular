import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';

class CustomTextButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonName;
  final TextStyle buttonStyle;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    required this.buttonStyle,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: SizeConfig.defaultSize * 13,
        height: 50,
        child: Card(
          color: COLOR_CONST.primaryColor,
          shape: RoundedRectangleBorder(
            // Set rounded borders
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(buttonName, style: buttonStyle),
          ),
        ),
      ),
    );
  }
}
