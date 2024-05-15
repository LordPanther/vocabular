// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:vocab_app/configs/settings.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/presentation/common_blocs/app_settings/app_settings_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/app_settings/app_settings_event.dart';
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
  final AuthRepository _authRepository = AppRepository.authRepository;
  late Locale selectedLanguage;
  List<Locale> supportLanguage = AppLanguage.supportLanguage;
  bool? show = RecentWordSetting.defaultWordSetting;
  bool get isAnonymous => _authRepository.currentUser.isAnonymous;

  @override
  void initState() {
    super.initState();
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
                _buildCollectionsSettings(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildLanguageSettings(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                !isAnonymous
                    ? _buildRecentWordSettings()
                    : const SizedBox.shrink(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                // _buildThemeSettings(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentWordSettings() {
    return SettingsButton(
      icon: CupertinoIcons.app_badge,
      title: Translate.of(context).translate("recent_word"),
      leader: Transform.scale(
        scale: 0.7,
        child: Switch.adaptive(
          value: show!,
          onChanged: (onOff) {
            setState(() {
              show = !show!;
            });
            BlocProvider.of<AppSettingsBloc>(context)
                .add(ShowHideRecentWord(show!));
          },
        ),
      ),
      onPressed: () {},
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

  Widget _buildCollectionsSettings() {
    return SettingsButton(
      icon: CupertinoIcons.list_dash,
      title: Translate.of(context).translate("collections"),
      leader: const Text(""),
      onPressed: () => _showCollectionPage(),
    );
  }

  Widget _buildLanguageSettings() {
    return SettingsButton(
      icon: CupertinoIcons.globe,
      title: Translate.of(context).translate("language"),
      leader: Text(Translate.of(context).translate(
        UtilLanguage.getLanguageName(AppLanguage.defaultLanguage.languageCode),
      )),
      onPressed: () => _showLanguageSetting(),
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
      BlocProvider.of<AppSettingsBloc>(context)
          .add(ChangeLanguage(selectedLanguage));
    }
  }
}
