import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/breathing_icon.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const RecordButton({super.key, required this.isRecording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: SizeConfig.defaultSize * 4,
        height: SizeConfig.defaultSize * 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isRecording ? Colors.redAccent : COLOR_CONST.primaryColor,
        ),
        child: Center(
          child: BreathingIcon(
            recording: isRecording,
            iconData: CupertinoIcons.mic,
            color: COLOR_CONST.textColor,
          ),
        ),
      ),
    );
  }
}
