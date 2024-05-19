import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/image_constant.dart';

class AddCollectionHeader extends StatelessWidget {
  const AddCollectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.defaultSize * 7,
        bottom: SizeConfig.defaultSize * 7,
        right: SizeConfig.defaultSize * 1.5,
        left: SizeConfig.defaultSize * 1.5,
      ),
      // color: COLOR_CONST.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.defaultSize * 5,
            child: Image.asset(IMAGE_CONST.LOGIN_BANNER),
          ),
        ],
      ),
    );
  }
}
