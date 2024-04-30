import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/login/widgets/login_form.dart';
import 'package:vocab_app/presentation/screens/login/widgets/login_header.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/config.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                LoginHeader(),
                LoginForm(),
              ],
            ),
          ),
          bottomNavigationBar: _buildNoAccountText(context),
        ),
      ),
    );
  }

  _buildNoAccountText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Translate.of(context).translate('don\'t_have_an_account'),
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.INITIALIZE_INFO,
            ),
            child: Text(
              Translate.of(context).translate('sign_up'),
              style: FONT_CONST.BOLD_DEFAULT_16,
            ),
          ),
        ],
      ),
    );
  }
}
