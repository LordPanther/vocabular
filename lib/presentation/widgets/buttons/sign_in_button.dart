import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';

class SignInButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final String text;
  final Color backgroundColor;

  const SignInButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.text,
    this.backgroundColor = COLOR_CONST.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.defaultSize * 4,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
        child: Row(
          children: [
            child,
            SizedBox(width: SizeConfig.defaultSize * 0.7),
            Text(text, overflow: TextOverflow.clip),
          ],
        ),
      ),
    );
  }
}
