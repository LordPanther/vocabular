import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/breathing_icon.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final double progress;
  final VoidCallback onTap;

  const RecordButton(
      {super.key,
      required this.isRecording,
      required this.progress,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
          SizeConfig.defaultSize * 1.2), // Add padding around the InkWell
      margin: EdgeInsets.all(
          SizeConfig.defaultSize * 1.6), // Add margin around the Container
      decoration: BoxDecoration(
        color: COLOR_CONST.backgroundColor, // Background color of the Container
        borderRadius: BorderRadius.circular(
            SizeConfig.defaultSize * 3), // Rounded corners
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: SizeConfig.defaultSize * 5,
          height: SizeConfig.defaultSize * 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.defaultSize * 2),
                  color:
                      isRecording ? Colors.redAccent : COLOR_CONST.primaryColor,
                ),
              ),
              CircularProgressIndicator(
                value: progress,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    COLOR_CONST.primaryColor),
                backgroundColor: COLOR_CONST.borderColor,
                strokeWidth: 5,
              ),
              Center(
                child: BreathingIcon(
                  recording: isRecording,
                  iconData:
                      isRecording ? CupertinoIcons.stop : CupertinoIcons.mic,
                  color: COLOR_CONST.activeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
