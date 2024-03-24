// ignore_for_file: library_private_types_in_public_api

import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/default_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/main_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/config.dart';
import '../../../common_blocs/auth/auth_bloc.dart';
import '../../../common_blocs/auth/auth_event.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late LoginBloc loginBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = false;

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled() {
    return loginBloc.state.isFormValid &&
        !loginBloc.state.isSubmitting &&
        isPopulated;
  }

  void onLogin() {
    if (isLoginButtonEnabled()) {
      loginBloc.add(LoginWithCredential(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  void onForgotPassword() {
    Navigator.pushNamed(context, AppRouter.FORGOT_PASSWORD);
  }

  void onGoogleLogin() {
    loginBloc.add(const LoginWithGoogleSignIn());
  }

  void onFacebookLogin() {
    UtilSnackBar.showSnackBarContent(context,
        content: "Button not yet supported");
  }

  void onTwitterLogin() {
    UtilSnackBar.showSnackBarContent(context,
        content: "Button not yet supported");
  }

  void onAppleLogin() {
    UtilSnackBar.showSnackBarContent(context,
        content: "Button not yet supported");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        /// Success
        if (state.isSuccess) {
          // UtilDialog.hideWaiting(context);
          BlocProvider.of<AuthenticationBloc>(context).add(LogIn());
        }

        /// Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }

        /// Logging
        if (state.isSubmitting) {
          // UtilDialog.showWaiting(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding,
              vertical: SizeConfig.defaultSize * 3,
            ),
            child: Form(
              child: Column(
                children: <Widget>[
                  _buildHeaderText(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildTextFieldUsername(),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildTextFieldPassword(),
                  SizedBox(height: SizeConfig.defaultSize * 1),
                  _buildForgotPassword(),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildButtonLogin(state),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      _buildTextOr(),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGoogleButton(state),
                      ),
                      SizedBox(width: SizeConfig.defaultSize * 2),
                      Expanded(child: _buildFacebookLogin(state)),
                      SizedBox(width: SizeConfig.defaultSize * 2),
                      Expanded(child: _buildTwitterLogin(state)),
                      SizedBox(width: SizeConfig.defaultSize * 2),
                      Expanded(child: _buildAppleLogin(state)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate('login'),
        style: FONT_CONST.BOLD_DEFAULT_16,
      ),
    );
  }

  /// Build content
  _buildTextFieldUsername() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: emailController,
      onChanged: (value) {
        loginBloc.add(EmailChanged(email: value));
      },
      validator: (_) {
        return !loginBloc.state.isEmailValid
            ? Translate.of(context).translate('invalid_email')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('email'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildTextFieldPassword() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: passwordController,
      textInputAction: TextInputAction.go,
      onChanged: (value) {
        loginBloc.add(PasswordChanged(password: value));
      },
      validator: (_) {
        return !loginBloc.state.isPasswordValid
            ? Translate.of(context).translate('invalid_password')
            : null;
      },
      onEditingComplete: onLogin,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      obscureText: !isShowPassword,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('password'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
          suffixIcon: IconButton(
            icon: isShowPassword
                ? Icon(Icons.visibility_outlined,
                    color: COLOR_CONST.textColor,
                    size: SizeConfig.defaultSize * 2)
                : Icon(Icons.visibility_off_outlined,
                    color: COLOR_CONST.textColor,
                    size: SizeConfig.defaultSize * 2),
            onPressed: () {
              setState(() => isShowPassword = !isShowPassword);
            },
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onForgotPassword,
        child: Text(
          Translate.of(context).translate('forgot_password'),
          style: FONT_CONST.BOLD_DEFAULT_16,
        ),
      ),
    );
  }

  _buildButtonLogin(LoginState state) {
    return SizedBox(
      width: SizeConfig.defaultSize * 15,
      child: MainButton(
        borderRadius: SizeConfig.defaultSize * 0.5,
        onPressed: onLogin,
        backgroundColor: isLoginButtonEnabled()
            ? COLOR_CONST.primaryColor
            : COLOR_CONST.cardShadowColor,
        child: Text(
          Translate.of(context).translate('login'),
          style: FONT_CONST.BOLD_BLACK_18,
        ),
      ),
    );
  }

  _buildAppleLogin(LoginState state) {
    return DefaultButton(
      onPressed: onAppleLogin,
      child: Image.asset(IMAGE_CONST.APPLE_LOGO),
    );
  }

  _buildTwitterLogin(LoginState state) {
    return DefaultButton(
      onPressed: onTwitterLogin,
      child: Image.asset(IMAGE_CONST.TWITTER_LOGO),
    );
  }

  _buildFacebookLogin(LoginState state) {
    return DefaultButton(
      onPressed: onFacebookLogin,
      child: Image.asset(IMAGE_CONST.FACEBOOK_LOGO),
    );
  }

  _buildTextOr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Divider(color: COLOR_CONST.dividerColor),
        SizedBox(width: SizeConfig.defaultSize * 1),
        Text(Translate.of(context).translate('or'),
            style: FONT_CONST.REGULAR_DEFAULT_16),
        SizedBox(width: SizeConfig.defaultSize * 1),
        const Divider(color: COLOR_CONST.dividerColor),
      ],
    );
  }

  _buildGoogleButton(LoginState state) {
    return DefaultButton(
      onPressed: () {},
      child: Image.asset(IMAGE_CONST.GOOGLE_LOGO),
    );
  }
}
