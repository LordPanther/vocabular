import 'package:flutter/material.dart';

import '../../../configs/config.dart';
import '../../../constants/font_constant.dart';

class TextRow extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final bool isSpaceBetween;

  const TextRow({
    super.key,
    required this.title,
    required this.content,
    this.isSpaceBetween = false,
    this.titleStyle,
    this.contentStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 0.5),
      child: isSpaceBetween
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: FONT_CONST.BOLD_PRIMARY_18,
                ),
                Text(
                  content,
                  style: FONT_CONST.BOLD_DEFAULT_18,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SizeConfig.defaultSize * 15,
                  child: Text(
                    title,
                    style: titleStyle ?? FONT_CONST.BOLD_DEFAULT_16,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: contentStyle ?? FONT_CONST.REGULAR_DEFAULT_16,
                  ),
                )
              ],
            ),
    );
  }
}
