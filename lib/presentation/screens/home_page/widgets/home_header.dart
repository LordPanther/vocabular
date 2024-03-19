import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/others/search_field_widget.dart';
import 'package:vocab_app/utils/translate.dart';

class HomePersistentHeader extends SliverPersistentHeaderDelegate {
  final double _mainHeaderHeight = SizeConfig.defaultSize * 4;
  final double _insetVertical = SizeConfig.defaultSize * 1.5;
  final double _searchFieldHeight = SizeConfig.defaultSize * 5;
  final double _insetHorizontal = SizeConfig.defaultSize * 1.5;
  // _mainHeaderHeight + 2*_insetVertical
  final double _minHeaderExtent = SizeConfig.defaultSize * 8;
  // _mainHeaderHeight + _searchFieldHeight + 2*_insetVertical + whiteSpace
  final double _maxHeaderExtent =
      SizeConfig.defaultSize * 13 + SizeConfig.defaultSize / 2;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //final size = MediaQuery.of(context).size;
    final offsetPercent = shrinkOffset / _maxHeaderExtent;
    //var rangeSearchFieldWidth = (1 - offsetPercent).clamp(0.85, 1);
    return AnimatedContainer(
      duration: mAnimationDuration,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: COLOR_CONST.cardShadowColor.withOpacity(0.2),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: _insetVertical,
            left: _insetHorizontal,
            right: _insetHorizontal,
            height: _mainHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.line_horizontal_3),
                ),
                //const Spacer(),
                AnimatedOpacity(
                  opacity: offsetPercent > 0.1 ? 0 : 1,
                  duration: const Duration(microseconds: 500),
                  child: Text("Vocabula®", style: FONT_CONST.BOLD_PRIMARY_18),
                ),
                //const Spacer(),
                IconButton(
                    onPressed: () {}, icon: const Icon(CupertinoIcons.bag)),
              ],
            ),
          ),
          Positioned.directional(
            bottom: _insetVertical,
            height: _searchFieldHeight,
            start: 50,
            end: 50,
            textDirection: TextDirection.ltr,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: _insetHorizontal),
              child: SearchFieldWidget(
                readOnly: true,
                onTap: () {},
                hintText: Translate.of(context).translate('search'),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
