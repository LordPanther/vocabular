import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/utils/translate.dart';

class FormDialog extends StatefulWidget {
  final String option;
  const FormDialog({super.key, required this.option});

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final TextEditingController word = TextEditingController();

  final TextEditingController definition = TextEditingController();

  final TextEditingController collection = TextEditingController();

  @override
  void dispose() {
    word.dispose();
    definition.dispose();
    super.dispose();
  }

  bool get isWordPopulated => word.text.isNotEmpty;
  bool get isCollectionPopulated => collection.text.isNotEmpty;

  void addData(String option) {
    if (option == "collection" && isCollectionPopulated) {
      CollectionModel collectionModel = CollectionModel(
        name: collection.text,
      );
      Navigator.of(context).pop(collectionModel);
    } else if (option == "word" && isWordPopulated) {
      WordModel wordModel = WordModel(
        id: "",
        definition: definition.text,
        word: word.text,
      );
      Navigator.of(context).pop(wordModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userOption = widget.option;
    return AlertDialog(
      title: Text("Add new $userOption"),
      content: userOption == "word"
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeaderText("Add new word..."),
                SizedBox(
                  height: SizeConfig.defaultSize * 3,
                ),
                _buildTextFieldWord(),
                _buildTextFieldDefinition(),
                _buildButtonProcessAction()
              ],
            )
          : Column(
              children: [
                _buildHeaderText("Add new collection..."),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildTextFieldCollection(),
                SizedBox(height: SizeConfig.defaultSize * 3),
                _buildButtonProcessAction()
              ],
            ),
    );
  }

  /// Header text
  _buildHeaderText(String userOption) {
    return Center(
      child: Text(
        userOption,
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  /// Word
  _buildTextFieldWord() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: word,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('add_word'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  /// Definition
  _buildTextFieldDefinition() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: definition,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('add_definition'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildTextFieldCollection() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: collection,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('collection_name'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => addData(widget.option),
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        IconButton(
          onPressed: () => addData(widget.option),
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
