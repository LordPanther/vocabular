import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/default_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/config.dart';
import '../new/new_password_bloc.dart';
import '../new/new_password_event.dart';
import '../new/new_password_state.dart';

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  late NewPasswordBloc newPasswordBloc;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  @override
  void initState() {
    newPasswordBloc = BlocProvider.of<NewPasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  bool get isPasswordPopulated =>
      newPasswordController.text.isNotEmpty &&
      confirmNewPasswordController.text.isNotEmpty &&
      newPasswordController.text.length ==
          confirmNewPasswordController.text.length;

  bool isResetPasswordButtonEnabled() {
    return isPasswordPopulated;
  }

  void onResetPassword() {
    if (isResetPasswordButtonEnabled()) {
      String newPassword = newPasswordController.text;
      newPasswordBloc.add(ResetPassword(newPassword: newPassword));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewPasswordBloc, NewPasswordState>(
      listener: (context, state) {
        /// Registering
        if (state.isSubmitting) {
          UtilDialog.showWaiting(context);
        }

        /// Success
        if (state.isSuccess) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate('password_reset'));
          Navigator.pushNamed(context, AppRouter.CONFIRM_PASSWORD_RESET);
        }

        /// Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<NewPasswordBloc, NewPasswordState>(
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
                _buildHeaderText(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildNewPasswordInput(),
                SizedBox(height: SizeConfig.defaultSize * 2),
                _buildConfirmNewPasswordInput(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildButtonResetPassword(),
              ],
            )),
          );
        },
      ),
    );
  }

  _buildHeaderText() {
    return Center(
      child: Text(Translate.of(context).translate('new_password')),
    );
  }

  _buildNewPasswordInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: newPasswordController,
      onChanged: (value) {
        newPasswordBloc.add(NewPasswordChanged(newPassword: value));
      },
      validator: (_) {
        return !newPasswordBloc.state.isNewPasswordValid
            ? Translate.of(context).translate('invalid_password')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      obscureText: !isShowPassword,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        labelText: Translate.of(context).translate('password'),
        suffixIcon: IconButton(
          icon: isShowPassword
              ? Icon(Icons.visibility_outlined,
                  color: COLOR_CONST.textColor,
                  size: SizeConfig.defaultSize * 2)
              : Icon(Icons.visibility_off_outlined,
                  color: COLOR_CONST.textColor,
                  size: SizeConfig.defaultSize * 2),
          onPressed: () {
            setState(() {
              isShowPassword = !isShowPassword;
            });
          },
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
      ),
    );
  }

  _buildConfirmNewPasswordInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: confirmNewPasswordController,
      onChanged: (value) {
        newPasswordBloc.add(ConfirmNewPasswordChanged(
          newPassword: newPasswordController.text,
          confirmNewPassword: value,
        ));
      },
      validator: (_) {
        return !newPasswordBloc.state.isConfirmNewPasswordValid
            ? Translate.of(context).translate('don\'t_match_password')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      obscureText: !isShowConfirmPassword,
      decoration: InputDecoration(
        labelText: Translate.of(context).translate('confirm_password'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        suffixIcon: IconButton(
          icon: isShowConfirmPassword
              ? Icon(Icons.visibility_outlined,
                  color: COLOR_CONST.textColor,
                  size: SizeConfig.defaultSize * 2)
              : Icon(Icons.visibility_off_outlined,
                  color: COLOR_CONST.textColor,
                  size: SizeConfig.defaultSize * 2),
          onPressed: () {
            setState(() {
              isShowConfirmPassword = !isShowConfirmPassword;
            });
          },
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
      ),
    );
  }

  _buildButtonResetPassword() {
    return DefaultButton(
      onPressed: onResetPassword,
      backgroundColor: isResetPasswordButtonEnabled()
          ? COLOR_CONST.primaryColor
          : COLOR_CONST.cardShadowColor,
      child: Text(
        Translate.of(context).translate('reset_password').toUpperCase(),
        style: FONT_CONST.BOLD_BLACK_18,
      ),
    );
  }
}
