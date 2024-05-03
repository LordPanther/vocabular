import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';

class MainButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonName;
  final TextStyle buttonStyle;

  const MainButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    required this.buttonStyle,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed, child: Text(buttonName, style: buttonStyle));
  }
}
