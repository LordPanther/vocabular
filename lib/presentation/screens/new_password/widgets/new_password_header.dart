import 'package:vocab_app/constants/image_constant.dart';
import 'package:flutter/material.dart';

import '../../../../configs/config.dart';

class NewPasswordHeader extends StatelessWidget {
  const NewPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.defaultSize * 10,
        bottom: SizeConfig.defaultSize * 5,
        right: SizeConfig.defaultSize * 1.5,
        left: SizeConfig.defaultSize * 1.5,
      ),
      // color: COLOR_CONST.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.defaultSize * 10,
            child: Image.asset(IMAGE_CONST.LOGIN_BANNER),
          ),
        ],
      ),
    );
  }
}
