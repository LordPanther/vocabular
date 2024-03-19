import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/default_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/config.dart';
import '../confirm/confirmation_bloc.dart';
import '../confirm/confirmation_event.dart';
import '../confirm/confirmation_state.dart';

class ConfirmationBody extends StatefulWidget {
  final String newPassword;
  const ConfirmationBody({super.key, required this.newPassword});

  @override
  State<ConfirmationBody> createState() => _ConfirmationBodyState();
}

class _ConfirmationBodyState extends State<ConfirmationBody> {
  late ConfirmationBloc confirmationBloc;
  final List<String> confirmationCode = [];

  @override
  void initState() {
    confirmationBloc = BlocProvider.of<ConfirmationBloc>(context);
    super.initState();
  }

  bool get isPopulated => confirmationCode.isNotEmpty;

  bool isConfirmResetButtonEnabled() {
    return isPopulated;
  }

  void onConfirmReset() {
    if (isPopulated) {
      final String code = confirmationCode.join();
      final String password = widget.newPassword;

      confirmationBloc
          .add(ConfirmResetCodeEvent(code: code, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfirmationBloc, ConfirmationState>(
      listener: (context, state) {
        ///Confirming
        if (state.isSubmitting) {
          UtilDialog.showWaiting(context);
        }

        ///Success
        if (state.isSuccess) {
          UtilSnackBar.showSnackBarContent(context,
              content: "Password changed succesfully");
        }

        ///Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<ConfirmationBloc, ConfirmationState>(
          builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.defaultPadding * 3,
            vertical: SizeConfig.defaultSize * 10,
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "We have sent you a 6 digit verification code. Plese enter it now to complete the password reset process.",
                ),
                SizedBox(height: SizeConfig.defaultSize * 5),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCodeAfield(),
                    SizedBox(width: SizeConfig.defaultSize * 0.5),
                    _buildCodeBfield(),
                    SizedBox(width: SizeConfig.defaultSize * 0.5),
                    _buildCodeCfield(),
                    SizedBox(width: SizeConfig.defaultSize * 0.5),
                    _buildCodeDfield(),
                    SizedBox(width: SizeConfig.defaultSize * 0.5),
                    _buildCodeEfield(),
                    SizedBox(width: SizeConfig.defaultSize * 0.5),
                    _buildCodeFfield()
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize * 5),
                _buildButtonForgotPassword(),
              ],
            ),
          ),
        );
      }),
    );
  }

  _buildButtonForgotPassword() {
    return DefaultButton(
      onPressed: onConfirmReset,
      backgroundColor: isConfirmResetButtonEnabled()
          ? COLOR_CONST.primaryColor
          : COLOR_CONST.cardShadowColor,
      child: Text(
        Translate.of(context).translate('confirm_email').toUpperCase(),
        style: FONT_CONST.BOLD_BLACK_18,
      ),
    );
  }

  _buildCodeAfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value1) {
          confirmationCode.add(value1);
          if (value1.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }

  _buildCodeBfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value2) {
          confirmationCode.add(value2);
          if (value2.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }

  _buildCodeCfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value3) {
          confirmationCode.add(value3);
          if (value3.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }

  _buildCodeDfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value4) {
          confirmationCode.add(value4);
          if (value4.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }

  _buildCodeEfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value5) {
          confirmationCode.add(value5);
          if (value5.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }

  _buildCodeFfield() {
    return Expanded(
      child: TextFormField(
        onChanged: (value6) {
          confirmationCode.add(value6);
          if (value6.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: const TextStyle(color: COLOR_CONST.textColor),
        cursorColor: COLOR_CONST.textColor,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: COLOR_CONST.textColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor))),
      ),
    );
  }
}
