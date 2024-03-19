import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/screens/register/register/register_bloc.dart';
import 'package:vocab_app/presentation/screens/register/widgets/register_form.dart';
import 'package:vocab_app/presentation/screens/register/widgets/register_header.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/config.dart';

class RegisterScreen extends StatelessWidget {
  final UserModel selection;

  const RegisterScreen({super.key, required this.selection});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const RegisterHeader(),
                RegisterForm(selection: selection),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Translate.of(context).translate('already_have_an_account'),
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.LOGIN,
              (_) => false,
            ),
            child: Text(
              Translate.of(context).translate('login'),
              style: FONT_CONST.BOLD_DEFAULT_16,
            ),
          ),
        ],
      ),
    );
  }
}
