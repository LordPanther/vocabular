// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_event.dart';
import 'package:vocab_app/presentation/screens/login/bloc/login_bloc.dart';
import 'package:vocab_app/presentation/screens/login/bloc/login_event.dart';
import 'package:vocab_app/presentation/screens/login/bloc/login_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/sign_in_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late LoginBloc _loginBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isShowPassword = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled() {
    bool buttonEnabled = _loginBloc.state.isFormValid &&
        !_loginBloc.state.isSubmitting &&
        isPopulated;
    return buttonEnabled;
  }

  void onSignIn() {
    if (isLoginButtonEnabled()) {
      _loginBloc.add(SignInWithCredentials(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  void onGuestSignIn() {
    _loginBloc.add(const SignInAsGuest());
  }

  void onGoogleSignUp() {
    _loginBloc.add(const SignInWithGoogleSignIn());
  }

  void onForgotPassword() {
    Navigator.pushNamed(context, AppRouter.FORGOT_PASSWORD);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        /// Success
        if (state.isSuccess) {
          UtilDialog.hideWaiting(context);
          BlocProvider.of<AuthenticationBloc>(context).add(LogIn());
        }

        /// Failure
        if (state.isFailure) {
          if (state.message!.split(" ").last == "google") {
            if (kDebugMode) {
              print(state.message);
            }
            UtilDialog.hideWaiting(context);
            Navigator.pushNamed(context, AppRouter.LOGIN);
          } else {
            UtilDialog.hideWaiting(context);
            UtilDialog.showInformation(context, content: state.message);
          }
        }

        /// Logging
        if (state.isSubmitting) {
          UtilDialog.showWaiting(context);
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
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildHeaderText(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildTextFieldEmail(),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildTextFieldPassword(),
                  SizedBox(height: SizeConfig.defaultSize * 1),
                  _buildForgotPassword(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildButtonLogin(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(color: COLOR_CONST.dividerColor)),
                      _buildTextOr(),
                      const Expanded(
                          child: Divider(color: COLOR_CONST.dividerColor)),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  Row(
                    children: [
                      Expanded(child: _buildGoogleSignIn()),
                      SizedBox(width: SizeConfig.defaultSize * 2),
                      Expanded(child: _buildGuestSignIn()),
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
        Translate.of(context).translate("sign_in"),
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  /// Build content
  _buildTextFieldEmail() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _emailController,
      onChanged: (value) {
        _loginBloc.add(EmailChanged(email: value));
      },
      validator: (_) {
        return !_loginBloc.state.isEmailValid
            ? Translate.of(context).translate("invalid_email")
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("email"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.primaryColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.primaryColor))),
    );
  }

  _buildTextFieldPassword() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _passwordController,
      onChanged: (value) {
        _loginBloc.add(PasswordChanged(password: value));
      },
      validator: (_) {
        return !_loginBloc.state.isPasswordValid
            ? Translate.of(context).translate("invalid_password")
            : null;
      },
      onEditingComplete: () {},
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      obscureText: !_isShowPassword,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("password"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
          suffixIcon: IconButton(
            icon: _isShowPassword
                ? Icon(Icons.visibility_outlined,
                    color: COLOR_CONST.primaryColor,
                    size: SizeConfig.defaultSize * 2)
                : Icon(Icons.visibility_off_outlined,
                    color: COLOR_CONST.textColor,
                    size: SizeConfig.defaultSize * 2),
            onPressed: () {
              setState(() => _isShowPassword = !_isShowPassword);
            },
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.primaryColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.primaryColor))),
    );
  }

  _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onForgotPassword,
        child: Text(
          Translate.of(context).translate("forgot_password"),
          style: FONT_CONST.BOLD_DEFAULT_16,
        ),
      ),
    );
  }

  _buildButtonLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isLoginButtonEnabled())
          MainButton(
            onPressed: onSignIn,
            buttonName: Translate.of(context).translate("sign_in"),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
      ],
    );
  }

  _buildTextOr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(width: SizeConfig.defaultSize * 1),
        Text(Translate.of(context).translate("or"),
            style: FONT_CONST.MEDIUM_DEFAULT_16),
        SizedBox(width: SizeConfig.defaultSize * 1),
      ],
    );
  }

  _buildGoogleSignIn() {
    return SignInButton(
      onPressed: onGoogleSignUp,
      text: Translate.of(context).translate("google"),
      child: Image.asset(IMAGE_CONST.GOOGLE_LOGO),
    );
  }

  _buildGuestSignIn() {
    return SignInButton(
      onPressed: onGuestSignIn,
      text: Translate.of(context).translate("guest"),
      child: const Icon(CupertinoIcons.profile_circled),
    );
  }
}
