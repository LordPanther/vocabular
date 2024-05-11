// ignore_for_file: library_private_types_in_public_api

import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/default_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  late ForgotPasswordBloc forgotPasswordBloc;
  // late UserModel user;

  // local states
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool get isEmailPopulated => emailController.text.isNotEmpty;

  bool isSendResetEmailButtonEnabled() {
    return forgotPasswordBloc.state.isFormValid &&
        !forgotPasswordBloc.state.isSubmitting &&
        isEmailPopulated;
  }

  void onSendResetEmail() {
    if (isSendResetEmailButtonEnabled()) {
      forgotPasswordBloc
          .add(ResetPasswordEvent(email: emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        /// Submitting
        if (state.isSubmitting) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate("reset_email"));
        }

        /// Success
        if (state.isSuccess) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate("reset_send"));
          Navigator.pushReplacementNamed(context, AppRouter.NEW_PASSWORD);
        }

        ///Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding * 2,
              vertical: SizeConfig.defaultSize * 3,
            ),
            child: Form(
                child: Column(
              children: [
                Text(
                  Translate.of(context).translate("reset_link"),
                ),
                SizedBox(height: SizeConfig.defaultSize * 5),
                _buildEmailFormField(),
                SizedBox(height: SizeConfig.defaultSize * 5),
                _buildButtonForgotPassword(),
              ],
            )),
          );
        },
      ),
    );
  }

  _buildEmailFormField() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: emailController,
      onChanged: (value) {
        forgotPasswordBloc.add(EmailChanged(email: value));
      },
      validator: (_) {
        return !forgotPasswordBloc.state.isEmailValid
            ? Translate.of(context).translate('invalid_email')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        labelText: Translate.of(context).translate('email'),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        // suffixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  _buildButtonForgotPassword() {
    return DefaultButton(
      onPressed: onSendResetEmail,
      backgroundColor: isSendResetEmailButtonEnabled()
          ? COLOR_CONST.primaryColor.withOpacity(0.3)
          : COLOR_CONST.cardShadowColor,
      child: Text(
        Translate.of(context).translate('confirm_email').toUpperCase(),
        style: FONT_CONST.BOLD_BLACK_18,
      ),
    );
  }
}
