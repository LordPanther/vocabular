import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';

import '../../../constants/image_constant.dart';

class LogoFull extends StatelessWidget {
  const LogoFull({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      IMAGE_CONST.SPLASH_LOGO,
      width: SizeConfig.defaultSize * 20,
      // height: SizeConfig.defaultSize * 15,
    );
  }
}
