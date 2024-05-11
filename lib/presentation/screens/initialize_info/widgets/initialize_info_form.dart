import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/utils/validator.dart';
import '../../../../configs/config.dart';

class InitializeInfoForm extends StatefulWidget {
  const InitializeInfoForm({super.key});

  @override
  State<InitializeInfoForm> createState() => _InitializeInfoFormState();
}

class _InitializeInfoFormState extends State<InitializeInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  bool get isPopulated =>
      _firstNameController.text.isNotEmpty ||
      _lastNameController.text.isNotEmpty;

  void onContinue() {
    if (_formKey.currentState!.validate()) {
      UserModel selection = UserModel(
        email: "",
        id: "",
        username: "",
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        avatar: "",
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
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildHeaderText(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildFirstNameInput(),
            SizedBox(height: SizeConfig.defaultSize * 2),
            _buildLastNameInput(),
            SizedBox(height: SizeConfig.defaultSize * 2),
            _buildSkipNote(),
            SizedBox(height: SizeConfig.defaultSize * 5),
            _buildButtonContinue(),
          ],
        ),
      ),
    );
  }

  _buildSkipNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isPopulated)
          const Text(
            "Note: You can skip this form and fill it in later in your profile.",
            softWrap: true,
            // overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate('join_family'),
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  _buildFirstNameInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (isPopulated) {
          return UtilValidators.isValidName(value!)
              ? null
              : Translate.of(context).translate("invalid_name");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("first_name"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // suffixIcon: const Icon(Icons.person_outline),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: COLOR_CONST.primaryColor.withOpacity(0.3)))),
    );
  }

  _buildLastNameInput() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (isPopulated) {
          return UtilValidators.isValidName(value!)
              ? null
              : Translate.of(context).translate("invalid_name");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: Translate.of(context).translate("last_name"),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // suffixIcon: const Icon(Icons.person_outline),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: COLOR_CONST.primaryColor.withOpacity(0.3)))),
    );
  }

  _buildButtonContinue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isPopulated)
          CustomTextButton(
            onPressed: onContinue,
            buttonName: Translate.of(context).translate('continue'),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
        if (!isPopulated)
          CustomTextButton(
            onPressed: onContinue,
            buttonName: Translate.of(context).translate('skip'),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
      ],
    );
  }
}
