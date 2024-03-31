import 'package:flutter/cupertino.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/main_button.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter/material.dart';
import '../../../../configs/config.dart';

class InitializeInfoSelection extends StatefulWidget {
  const InitializeInfoSelection({super.key});

  @override
  State<InitializeInfoSelection> createState() =>
      _InitializeInfoSelectionState();
}

class _InitializeInfoSelectionState extends State<InitializeInfoSelection> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void onContinue() {
    if (formKey.currentState!.validate()) {
      UserModel selection = UserModel(
        email: "",
        id: "",
        tier: "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        avatar: "",
        phoneNumber: "",
        verificationStatus: "",
      );
      Navigator.pushReplacementNamed(
        context,
        AppRouter.REGISTER,
        arguments: selection,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultPadding,
        vertical: SizeConfig.defaultSize * 3,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            _buildHeaderText(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildFirstNameInput(),
            SizedBox(height: SizeConfig.defaultSize * 2),
            _buildLastNameInput(),
            SizedBox(height: SizeConfig.defaultSize * 5),
            _buildButtonContinue(),
          ],
        ),
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

  _buildFirstNameInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: firstNameController,
      keyboardType: TextInputType.text,
      // validator: (value) {
      //   return UtilValidators.isValidName(value!)
      //       ? null
      //       : Translate.of(context).translate("invalid_name");
      // },
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("first_name"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // suffixIcon: const Icon(Icons.person_outline),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildLastNameInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: lastNameController,
      keyboardType: TextInputType.text,
      // validator: (value) {
      //   return UtilValidators.isValidName(value!)
      //       ? null
      //       : Translate.of(context).translate("invalid_name");
      // },
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("last_name"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // suffixIcon: const Icon(Icons.person_outline),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildButtonContinue() {
    return SizedBox(
      width: SizeConfig.defaultSize * 15,
      child: IconButton(
        onPressed: onContinue,
        icon: const Icon(CupertinoIcons.arrow_right_circle),
      ),
    );
  }

  // _buildButtonContinue() {
  //   return SizedBox(
  //     width: SizeConfig.defaultSize * 15,
  //     child: MainButton(
  //       borderRadius: SizeConfig.defaultSize * 0.5,
  //       onPressed: onContinue,
  //       backgroundColor: COLOR_CONST.primaryColor,
  //       child: Text(
  //         Translate.of(context).translate('continue'),
  //         style: FONT_CONST.BOLD_BLACK_18,
  //       ),
  //     ),
  //   );
  // }
}
