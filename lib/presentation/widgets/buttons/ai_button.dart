// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/image_constant.dart';

class AIButton extends StatefulWidget {
  final Function() onGenerate;
  const AIButton({super.key, required this.onGenerate});

  @override
  State<AIButton> createState() => AIButtonState();
}

class AIButtonState extends State<AIButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onGenerate,
      child: Container(
        width: SizeConfig.defaultSize * 4.5,
        height: SizeConfig.defaultSize * 4.5,
        decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage(IMAGE_CONST.AI_LOGO)),
          borderRadius: BorderRadius.circular(
              SizeConfig.defaultSize * 3), // Rounded corners
        ),
      ),
    );
  }
}
