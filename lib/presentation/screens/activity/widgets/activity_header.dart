import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';

class ActivityHeader extends StatefulWidget {
  const ActivityHeader({super.key});

  @override
  State<ActivityHeader> createState() => _ActivityHeaderState();
}

class _ActivityHeaderState extends State<ActivityHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 2.6),
      child: const Text(
        "Word Challenge",
        style: TextStyle(
            color: COLOR_CONST.textColor,
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontFamily: "Avenir"),
        textAlign: TextAlign.left,
      ),
    );
  }
}
