import 'package:flutter/cupertino.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/home_page/home_screen.dart';
import 'package:vocab_app/presentation/screens/profile/profile_screen.dart';
import 'package:vocab_app/presentation/screens/settings/setting_screen.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
        children: const <Widget>[
          SettingScreen(),
          HomeScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            activeIcon: const Icon(CupertinoIcons.settings),
            icon: const Icon(CupertinoIcons.settings,
                color: COLOR_CONST.textColor),
            label: Translate.of(context).translate('settings'),
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(CupertinoIcons.home),
            icon: const Icon(CupertinoIcons.home, color: COLOR_CONST.textColor),
            label: Translate.of(context).translate('home'),
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(CupertinoIcons.profile_circled),
            icon: const Icon(CupertinoIcons.profile_circled,
                color: COLOR_CONST.textColor),
            label: Translate.of(context).translate('profile'),
          ),
        ],
        selectedLabelStyle: FONT_CONST.BOLD_DEFAULT,
        selectedItemColor: COLOR_CONST.primaryColor,
        unselectedItemColor: COLOR_CONST.textColor,
        unselectedFontSize: 12,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
