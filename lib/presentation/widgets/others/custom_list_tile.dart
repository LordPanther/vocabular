import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/font_constant.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? subTitle;
  final Widget? trailing;
  final Widget? leading;
  final Function()? onPressed;
  final bool bottomBorder;

  const CustomListTile({
    super.key,
    required this.title,
    this.subTitle,
    this.trailing,
    this.leading,
    this.onPressed,
    this.bottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.defaultSize * 2,
          bottom: SizeConfig.defaultSize * 2,
          right: SizeConfig.defaultSize * 1.5,
        ),
        decoration: BoxDecoration(
          border: _bottomBorder(),
        ),
        child: Row(
          children: [
            _leadingWidget(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: FONT_CONST.REGULAR_DEFAULT_16, maxLines: 2),
                  _subTitle()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
              child: trailing ?? Container(),
            ),
          ],
        ),
      ),
    );
  }

  _subTitle() {
    return subTitle != null
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: subTitle,
          )
        : Container();
  }

  _leadingWidget() {
    return leading != null
        ? SizedBox(
            width: SizeConfig.defaultSize * 10,
            child: leading,
          )
        : Container();
  }

  _bottomBorder() {
    return bottomBorder
        ? const Border(
            bottom: BorderSide(
              width: 1,
              color: COLOR_CONST.dividerColor,
            ),
          )
        : null;
  }
}
