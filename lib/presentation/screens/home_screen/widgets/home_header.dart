import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/utils/translate.dart';

class HomeHeader extends StatelessWidget {

  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
      decoration: const BoxDecoration(
        color: COLOR_CONST.backgroundColor, // Adjust as needed
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              CupertinoIcons.profile_circled,
              size: SizeConfig.defaultIconSize,
            ),
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.PROFILE),
          ),
          Text(
            Translate.of(context).translate("app_name"),
            
            style: FONT_CONST.BOLD_PRIMARY_20,
          ),
          IconButton(
              icon: Icon(
                CupertinoIcons.search,
                size: SizeConfig.defaultIconSize,
              ),
              onPressed: () => Navigator.pushNamed(
                  context, AppRouter.SEARCH)
              ),
        ],
      ),
    );
  }
}
