import 'package:vocab_app/constants/image_constant.dart';
import 'package:flutter/material.dart';

import '../../../../configs/config.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.defaultSize * 10,
        bottom: SizeConfig.defaultSize * 5,
        right: SizeConfig.defaultSize * 3,
        left: SizeConfig.defaultSize * 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.defaultSize * 5,
            child: Image.asset(IMAGE_CONST.LOGIN_BANNER),
          )
        ],
      ),
    );
  }
}
