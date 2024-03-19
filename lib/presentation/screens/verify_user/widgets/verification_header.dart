import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:flutter/material.dart';

class VerificationHeader extends StatelessWidget {
  const VerificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.defaultSize * 15, bottom: SizeConfig.defaultSize * 8),
      child: SizedBox(
        height: SizeConfig.defaultSize * 10,
        child: Image.asset(IMAGE_CONST.LOGIN_BANNER),
      ),
    );
  }
}
