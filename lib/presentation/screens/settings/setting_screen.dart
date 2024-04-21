// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:vocab_app/presentation/common_blocs/language/bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/widgets/others/custom_list_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context).translate("settings"),
            style: const TextStyle(color: COLOR_CONST.primaryColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomListTile(
              title: Translate.of(context).translate("collections"),
              leading: const Icon(CupertinoIcons.list_dash,
                  color: COLOR_CONST.textColor),
              onPressed: () => _showCollectionPage(),
            ),
            CustomListTile(
              title: Translate.of(context).translate("language"),
              leading: const Icon(CupertinoIcons.globe,
                  color: COLOR_CONST.textColor),
              trailing: Text(
                Translate.of(context).translate(UtilLanguage.getLanguageName(
                    AppLanguage.defaultLanguage.languageCode)),
              ),
              onPressed: () => _showLanguageSetting(),
            ),
            CustomListTile(
              title: Translate.of(context).translate("theme"),
              leading: const Icon(CupertinoIcons.color_filter,
                  color: COLOR_CONST.textColor),
              onPressed: () => _showThemeDialog(),
            ),

          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {}

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
