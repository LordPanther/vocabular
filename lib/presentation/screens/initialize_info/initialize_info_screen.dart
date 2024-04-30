import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/initialize_info/widgets/initialize_info_header.dart';
import 'package:vocab_app/presentation/screens/initialize_info/widgets/initialize_info_form.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';

class InitializeInfoScreen extends StatelessWidget {
  const InitializeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              InitializeInfoHeader(),
              InitializeInfoForm(),
            ],
          ),
        ),
        bottomNavigationBar: _buildHaveAccount(context),
      ),
    );
  }

  _buildHaveAccount(context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.defaultSize * 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Translate.of(context).translate("already_have_an_account"),
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
          SizedBox(width: SizeConfig.defaultSize * 0.5),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.LOGIN,
              (route) => false,
            ),
            child: Text(
              Translate.of(context).translate("sign_in"),
              style: FONT_CONST.BOLD_DEFAULT_16,
            ),
          ),
        ],
      ),
    );
  }
}
