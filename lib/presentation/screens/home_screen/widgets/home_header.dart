import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';

class HomePersistentHeader extends SliverPersistentHeaderDelegate {
  final double _mainHeaderHeight = SizeConfig.defaultSize * 3;
  final double _insetVertical = SizeConfig.defaultSize * 1.5;
  final double _insetHorizontal = SizeConfig.defaultSize * 1.5;
  final double _minHeaderExtent = SizeConfig.defaultSize * 6;
  final double _maxHeaderExtent = SizeConfig.defaultSize * 7;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final offsetPercent = shrinkOffset / (_maxHeaderExtent - _minHeaderExtent);

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
                AnimatedOpacity(
                  opacity: offsetPercent > 0.1 ? 0 : 1,
                  duration: const Duration(microseconds: 500),
                  child: Text("Vocabula®", style: FONT_CONST.BOLD_PRIMARY_18),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.bag),
                ),
              ],
            ),
          ),
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
