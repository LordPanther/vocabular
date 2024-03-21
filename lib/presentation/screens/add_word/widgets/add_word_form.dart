import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';
import 'package:vocab_app/utils/translate.dart';

class AddWordForm extends StatefulWidget {
  const AddWordForm({super.key});

  @override
  State<AddWordForm> createState() => _AddWordFormState();
}

class _AddWordFormState extends State<AddWordForm> {
  late AddWordBloc addWordBloc;

  final formKey = GlobalKey<FormState>();
  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  final TextEditingController acronym = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    addWordBloc = BlocProvider.of<AddWordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    word.dispose();
    definition.dispose();
    acronym.dispose();
    note.dispose();
    super.dispose();
  }

  bool get isPopulated => word.text.isNotEmpty;

  bool isLoadWordButtonEnabled() {
    return addWordBloc.state.isFormValid &&
        !addWordBloc.state.isSubmitting &&
        isPopulated;
  }

  onAddToCollection() {
    print("Word added to collection");
  }

  void onAddWord() {
    if (formKey.currentState!.validate()) {
      WordModel wordModel = WordModel(
        id: "",
        audio: "",
        definition: definition.text,
        acronym: acronym.text,
        partOfSpeech: "",
        note: note.text,
        word: word.text,
      );

      if (isLoadWordButtonEnabled()) {
        addWordBloc.add(LoadWord(word: wordModel));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultSize * 3,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultPadding,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildHeaderText(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildTextFieldWord(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildTextFieldDefinition(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildTextFieldAcronym(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            _buildTextFieldNote(),
            SizedBox(height: SizeConfig.defaultSize * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButtonAddToCollection(),
                _buildButtonAddWord(),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate('add_word_form'),
        style: FONT_CONST.BOLD_DEFAULT_16,
      ),
    );
  }

  _buildTextFieldWord() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: word,
      onChanged: (value) {
        addWordBloc.add(WordChanged(word: value));
      },
      validator: (_) {
        return !addWordBloc.state.isWordValid
            ? Translate.of(context).translate('invalid_word')
            : null;
      },
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

  _buildTextFieldDefinition() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: definition,
      onChanged: (value) {
        addWordBloc.add(DefinitionChanged(definition: value));
      },
      validator: (_) {
        return !addWordBloc.state.isDefinitionValid
            ? Translate.of(context).translate('invalid_definition')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
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

  _buildTextFieldAcronym() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: acronym,
      onChanged: (value) {
        addWordBloc.add(AcronymChanged(acronym: value));
      },
      validator: (_) {
        return !addWordBloc.state.isAcronymValid
            ? Translate.of(context).translate('invalid_acronym')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('add_acronym'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildTextFieldNote() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: note,
      onChanged: (value) {
        addWordBloc.add(NoteChanged(note: value));
      },
      validator: (_) {
        return !addWordBloc.state.isNoteValid
            ? Translate.of(context).translate('invalid_note')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('add_note'),
          labelStyle: const TextStyle(color: COLOR_CONST.textColor),
          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textColor))),
    );
  }

  _buildButtonAddToCollection() {
    return TextButton(
      onPressed: onAddToCollection,
      child: const Text("+ Add collection"),
    );
  }

  _buildButtonAddWord() {
    return IconButton(
        onPressed: onAddWord, icon: const Icon(CupertinoIcons.arrow_right));
  }
}
