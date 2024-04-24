import 'package:flutter/cupertino.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';

class CircularVolumeIcon extends StatelessWidget {
  final Function()? onPlay;

  const CircularVolumeIcon({
    super.key,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.defaultSize * 4,
      height: SizeConfig.defaultSize * 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: COLOR_CONST.primaryColor,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.volume_up,
          color: COLOR_CONST.textColor,
          size: SizeConfig.defaultSize * 2.3, // Adjust the size of the icon
        ),
      ),
    );
  }
}
