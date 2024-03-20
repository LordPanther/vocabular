// ignore_for_file: library_private_types_in_public_api

import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/main_button.dart';
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

  // final formKey = GlobalKey<FormState>();
  // final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  @override
  void initState() {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    // phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      // phoneNumberController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled() {
    return registerBloc.state.isFormValid &&
        !registerBloc.state.isSubmitting &&
        isPopulated;
  }

  void onRegister() {
    if (isRegisterButtonEnabled()) {
      user = widget.selection!.cloneWith(
        email: emailController.text,
        // phoneNumber: phoneNumberController.text,
      );
      registerBloc.add(
        Submitted(
          user: user,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
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
              content: "Profile created successfully");
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
                  _buildButtonRegister(),
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
        Translate.of(context).translate('register'),
        style: FONT_CONST.BOLD_DEFAULT_16,
      ),
    );
  }

  /// Phone number
  // _buildPhoneNumberInput() {
  //   return TextFormField(
  //     style: TextStyle(
  //         color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
  //     controller: phoneNumberController,
  //     keyboardType: TextInputType.phone,
  //     onChanged: (value) {
  //       registerBloc.add(PhoneChanged(phoneNumber: value));
  //     },
  //     validator: (value) {
  //       return !registerBloc.state.isPhoneValid
  //           ? Translate.of(context).translate("invalid_phone_number")
  //           : null;
  //     },
  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //     decoration: InputDecoration(
  //       labelText: Translate.of(context).translate("phone_number"),
  //       labelStyle: const TextStyle(color: COLOR_CONST.textColor),
  //       // suffixIcon: const Icon(Icons.phone_callback_outlined),
  //       focusedBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: COLOR_CONST.textColor)),
  //       enabledBorder: const OutlineInputBorder(
  //           borderSide: BorderSide(color: COLOR_CONST.textColor)),
  //     ),
  //   );
  // }

  /// Build content
  _buildEmailInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: emailController,
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
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_CONST.textColor)),
        // suffixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  _buildPasswordInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: passwordController,
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
      controller: confirmPasswordController,
      onChanged: (value) {
        registerBloc.add(ConfirmPasswordChanged(
          password: passwordController.text,
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

  _buildButtonRegister() {
    return SizedBox(
      width: SizeConfig.defaultSize * 15,
      child: MainButton(
        borderRadius: SizeConfig.defaultSize * 0.5,
        onPressed: onRegister,
        backgroundColor: isRegisterButtonEnabled()
            ? COLOR_CONST.primaryColor
            : COLOR_CONST.cardShadowColor,
        child: Text(
          Translate.of(context).translate('sign_on').toUpperCase(),
          style: FONT_CONST.BOLD_BLACK_18,
        ),
      ),
    );
  }
}
