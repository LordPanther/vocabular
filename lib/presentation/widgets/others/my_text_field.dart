import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/utils/translate.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: COLOR_CONST.textColor,
        fontSize: SizeConfig.defaultSize * 1.6,
      ),
      minLines: 4,
      maxLines: 10,
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: controller,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.defaultSize,
          horizontal: SizeConfig.defaultSize * 1.5,
        ),
        labelText: Translate.of(context).translate('add_definition'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
        ),
      ),
    );
  }
}
