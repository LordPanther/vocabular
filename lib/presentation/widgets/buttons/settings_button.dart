import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/constants.dart';

class SettingsButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final String title;
  final String? leader;

  const SettingsButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.leader,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: SizeConfig.defaultSize * 1.7),
              Text(title, style: FONT_CONST.MEDIUM_DEFAULT_20),
            ],
          ),
          Text(leader!, style: FONT_CONST.MEDIUM_DEFAULT_16),
        ],
      ),
    );
  }
}
