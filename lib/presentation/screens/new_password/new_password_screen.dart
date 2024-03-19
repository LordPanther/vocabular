import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/new_password/widgets/new_password_form.dart';
import 'package:vocab_app/presentation/screens/new_password/widgets/new_password_header.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/config.dart';
import 'new/new_password_bloc.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                NewPasswordHeader(),
                NewPasswordForm(),
              ],
            ),
          ),
          bottomNavigationBar: _buildHaveAccountText(context),
        ),
      ),
    );
  }

  _buildHaveAccountText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
      child: GestureDetector(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.LOGIN,
          (_) => false,
        ),
        child: Text(
          Translate.of(context).translate('back_to_login'),
          style: FONT_CONST.BOLD_DEFAULT_16,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
