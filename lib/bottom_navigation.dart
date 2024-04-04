// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/collections/collections_screen.dart';
import 'package:vocab_app/presentation/screens/dictionary/dictionary_screen.dart';
import 'package:vocab_app/presentation/screens/home_screen/home_screen.dart';
import 'package:vocab_app/presentation/screens/profile/profile_screen.dart';
import 'package:vocab_app/presentation/screens/search/search_screen.dart';
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
          CollectionsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: Translate.of(context).translate('settings'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            label: Translate.of(context).translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.add),
            label: Translate.of(context).translate('add'),
          ),
        ],
        selectedLabelStyle: FONT_CONST.BOLD_DEFAULT,
        selectedItemColor: COLOR_CONST.primaryColor,
        unselectedFontSize: 12,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
