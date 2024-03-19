import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/forgot_password/widgets/forgot_pass_form.dart';
import 'package:vocab_app/presentation/screens/forgot_password/widgets/forgot_password_header.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/config.dart';
import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ForgotPasswordHeader(),
                ForgotPassForm(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBackToLoginText(context),
        ),
      ),
    );
  }

  _buildBackToLoginText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.LOGIN, (_) => false);
        },
        child: Text(
          textAlign: TextAlign.center,
          Translate.of(context).translate('back_to_login'),
          style: FONT_CONST.BOLD_DEFAULT_16,
        ),
      ),
    );
  }
}
