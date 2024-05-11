import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';

class SignInButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final String text;

  const SignInButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: SizeConfig.defaultSize * 4,
        decoration: BoxDecoration(
            color: COLOR_CONST.primaryColor.withOpacity(0.3),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              SizedBox(width: SizeConfig.defaultSize * 0.7),
              Text(text, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
