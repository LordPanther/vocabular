import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_event.dart';
import 'package:vocab_app/presentation/screens/verify_user/verify/verify_bloc.dart';
import 'package:vocab_app/presentation/screens/verify_user/verify/verify_event.dart';
import 'package:vocab_app/presentation/screens/verify_user/verify/verify_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  late VerificationBloc verificationBloc;

  @override
  void initState() {
    verificationBloc = BlocProvider.of<VerificationBloc>(context);
    verify();
    super.initState();
  }

  void goHome() {
    BlocProvider.of<AuthenticationBloc>(context).add(LogIn());
  }

  void verify() {
    verificationBloc.add(const SendVerificationEmailEvent());
  }

  void reVerify() {
    verificationBloc.add(const SendVerificationEmailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationBloc, VerificationState>(
      listener: (context, state) {
        /// Submitting
        if (state.isSubmitting) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate('verification_sent'));
        }

        /// Success
        if (state.isSuccess) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate('verification'));
          BlocProvider.of<AuthenticationBloc>(context).add(LogIn());
        }

        /// Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding * 1.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Translate.of(context).translate('verification_note'),
                  style: FONT_CONST.MEDIUM_DEFAULT_16,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: SizeConfig.defaultSize * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _resendButton(),
                    _continueButton(),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _continueButton() {
    return CustomTextButton(
      onPressed: goHome,
      buttonName: Translate.of(context).translate('continue'),
      buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
    );
  }

  _resendButton() {
    return CustomTextButton(
      onPressed: reVerify,
      buttonName: Translate.of(context).translate('resend_email_link'),
      buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
    );
  }
}
