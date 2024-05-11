// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/common_blocs/language/bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/presentation/screens/settings/settings_header.dart';
import 'package:vocab_app/presentation/widgets/buttons/settings_button.dart';
import 'package:vocab_app/utils/language.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Locale selectedLanguage;
  List<Locale> supportLanguage = AppLanguage.supportLanguage;
  String theme = "Light";

  void onThemeChange() {
    var data = MediaQuery.of(context).platformBrightness.name;
    print(data);
    setState(() {
      data == "light" ? ThemeData.dark() : ThemeData.light();
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.defaultPadding * 1.5),
            child: Column(
              children: [
                const SettingsHeader(),
                _buildHeaderText(),
                SizedBox(height: SizeConfig.defaultSize * 5),
                _buildCollectionsText(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildLanguageText(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildThemeText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate("settings"),
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  Widget _buildCollectionsText() {
    return SettingsButton(
      icon: CupertinoIcons.list_dash,
      title: Translate.of(context).translate("collections"),
      leader: "",
      onPressed: () => _showCollectionPage(),
    );
  }

  Widget _buildLanguageText() {
    return SettingsButton(
      icon: CupertinoIcons.globe,
      title: Translate.of(context).translate("language"),
      leader: Translate.of(context).translate(
        UtilLanguage.getLanguageName(AppLanguage.defaultLanguage.languageCode),
      ),
      onPressed: () => _showLanguageSetting(),
    );
  }

  Widget _buildThemeText() {
    return SettingsButton(
      icon: CupertinoIcons.color_filter,
      title: Translate.of(context).translate("theme"),
      leader: MediaQuery.of(context)
              .platformBrightness
              .name
              .substring(0, 1)
              .toUpperCase() +
          MediaQuery.of(context).platformBrightness.name.substring(1),
      onPressed: onThemeChange,
    );
  }

  void _showCollectionPage() {
    Navigator.pushNamed(context, AppRouter.COLLECTION);
  }

  void _showLanguageSetting() async {
    setState(() {
      selectedLanguage = AppLanguage.defaultLanguage;
    });
    final response = await UtilDialog.showConfirmation(
      context,
      title: Translate.of(context).translate("language_setting"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(supportLanguage.length, (index) {
              var language = supportLanguage[index];
              return CheckboxListTile(
                activeColor: COLOR_CONST.primaryColor,
                title: Text(
                  Translate.of(context).translate(
                      UtilLanguage.getLanguageName(language.languageCode)),
                ),
                value: language == selectedLanguage,
                onChanged: (value) {
                  setState(() => selectedLanguage = language);
                },
              );
            }),
          );
        },
      ),
      confirmButtonText: Translate.of(context).translate("select"),
    ) as bool;

    if (response) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<LanguageBloc>(context)
          .add(LanguageChanged(selectedLanguage));
    }
  }
}
