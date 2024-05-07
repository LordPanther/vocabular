import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/common_blocs/auth/bloc.dart';
import 'package:vocab_app/presentation/screens/guest_to_user_screen/bloc/guest_to_user_bloc.dart';
import 'package:vocab_app/presentation/screens/guest_to_user_screen/widget/guest_to_user_form.dart';
import 'package:vocab_app/presentation/screens/guest_to_user_screen/widget/guest_to_user_header.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/config.dart';

class GuestToUserScreen extends StatelessWidget {

  const GuestToUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestToUserBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                GuestToUserHeader(),
                GuestToUserForm(),
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
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
            },
            child: Text(
              Translate.of(context).translate('sign_in'),
              style: FONT_CONST.BOLD_DEFAULT_16,
            ),
          ),
        ],
      ),
    );
  }
}
