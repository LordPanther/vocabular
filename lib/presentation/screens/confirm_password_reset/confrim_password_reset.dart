import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/confirm_password_reset/widgets/confirmation_form.dart';
import 'package:vocab_app/presentation/screens/confirm_password_reset/widgets/confirmation_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'confirm/confirmation_bloc.dart';

class ConfirmPasswordResetScreen extends StatelessWidget {
  final String newPassword;
  const ConfirmPasswordResetScreen({super.key, required this.newPassword});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmationBloc(),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: COLOR_CONST.backgroundColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ConfirmationHeader(),
                  ConfirmationBody(newPassword: newPassword),
                ],
              ),
            ),
          )),
    );
  }
}
