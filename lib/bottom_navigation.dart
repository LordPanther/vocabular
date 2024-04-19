// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/add_word/add_word_screen.dart';
import 'package:vocab_app/presentation/screens/home_screen/home_screen.dart';
import 'package:vocab_app/presentation/screens/settings/setting_screen.dart';
import 'package:vocab_app/utils/translate.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation>
    with WidgetsBindingObserver {
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  ///On change tab bottom menu
  void onItemTapped(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          SettingScreen(),
          HomeScreen(),
          AddWordScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: SizeConfig.defaultIconSize,
              ),
              label: Translate.of(context).translate('settings'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: SizeConfig.defaultIconSize,
              ),
              label: Translate.of(context).translate('home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: SizeConfig.defaultIconSize,
              ),
              label: Translate.of(context).translate('add'),
            ),
          ],
          selectedLabelStyle: FONT_CONST.BOLD_DEFAULT,
          selectedItemColor: COLOR_CONST.primaryColor,
          backgroundColor: COLOR_CONST.backgroundColor,
          elevation: 0,
          // unselectedFontSize: SizeConfig.defaultSize * 1.2,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
