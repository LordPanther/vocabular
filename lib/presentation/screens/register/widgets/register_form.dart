// ignore_for_file: library_private_types_in_public_api

import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../configs/config.dart';
import '../register/register_bloc.dart';
import '../register/register_event.dart';
import '../register/register_state.dart';

class RegisterForm extends StatefulWidget {
  final UserModel? selection;
  const RegisterForm({super.key, this.selection});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late RegisterBloc registerBloc;
  late UserModel user;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool isSignUpButtonEnabled() {
    return registerBloc.state.isFormValid &&
        !registerBloc.state.isSubmitting &&
        isPopulated;
  }

  void onSignUp() {
    if (isSignUpButtonEnabled()) {
      user = widget.selection!.cloneWith(
        email: _emailController.text,
        // phoneNumber: phoneNumberController.text,
      );
      registerBloc.add(
        Submitted(
          user: user,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    } else {
      UtilDialog.showInformation(context,
          content: Translate.of(context)
              .translate("you_need_to_complete_all_fields"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        /// Registering
        if (state.isSubmitting) {
          UtilDialog.showWaiting(context);
        }

        /// Success
        if (state.isSuccess) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate('profile_created'));
          Navigator.pushNamed(context, AppRouter.VERIFY_USER, arguments: user);
        }

        /// Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding * 2,
              vertical: SizeConfig.defaultSize * 3,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildHeaderText(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildEmailInput(),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildPasswordInput(),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildConfirmPasswordInput(),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildButtonSignUp(),
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
        Translate.of(context).translate('sign_up'),
        style: FONT_CONST.BOLD_DEFAULT_16,
      ),
    );
  }

  _buildEmailInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _emailController,
      onChanged: (value) {
        registerBloc.add(EmailChanged(email: value));
      },
      validator: (_) {
        return !registerBloc.state.isEmailValid
            ? Translate.of(context).translate('invalid_email')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        labelText: Translate.of(context).translate('email'),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3))),
        // suffixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  _buildPasswordInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _passwordController,
      onChanged: (value) {
        registerBloc.add(PasswordChanged(password: value));
      },
      validator: (_) {
        return !registerBloc.state.isPasswordValid
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

  _buildConfirmPasswordInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _confirmPasswordController,
      onChanged: (value) {
        registerBloc.add(ConfirmPasswordChanged(
          password: _passwordController.text,
          confirmPassword: value,
        ));
      },
      validator: (_) {
        return !registerBloc.state.isConfirmPasswordValid
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

  _buildButtonSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isSignUpButtonEnabled())
          CustomTextButton(
            onPressed: onSignUp,
            buttonName: Translate.of(context).translate('sign_up'),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
      ],
    );
  }
}
