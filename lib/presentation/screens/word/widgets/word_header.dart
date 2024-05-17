import 'package:flutter/widgets.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/image_constant.dart';

class WordHeader extends StatelessWidget {
  const WordHeader({super.key});

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
      // color: COLOR_CONST.primaryColor.withOpacity(0.3),
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
