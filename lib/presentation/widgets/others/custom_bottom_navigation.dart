import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/utils/translate.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          activeIcon: const Icon(CupertinoIcons.search),
          icon: const Icon(CupertinoIcons.search, color: COLOR_CONST.textColor),
          label: Translate.of(context).translate('bottom_search'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.home),
          label: Translate.of(context).translate('home'),
        ),
        BottomNavigationBarItem(
          activeIcon: const Icon(CupertinoIcons.add),
          icon: const Icon(CupertinoIcons.add, color: COLOR_CONST.textColor),
          label: Translate.of(context).translate('add'),
        ),
      ],
      selectedLabelStyle: FONT_CONST.BOLD_DEFAULT,
      selectedItemColor: COLOR_CONST.primaryColor,
      unselectedItemColor: COLOR_CONST.textColor,
      unselectedFontSize: 12,
      onTap: onTap,
    );
  }
}
