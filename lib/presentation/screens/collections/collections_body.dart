import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/common_blocs/collections/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/custom_dismissible.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/translate.dart';

class ListCollectionsModel extends StatefulWidget {
  const ListCollectionsModel({super.key});

  @override
  State<ListCollectionsModel> createState() => _ListCollectionsModelState();
}

class _ListCollectionsModelState extends State<ListCollectionsModel> {
  late CollectionsBloc addWordBloc;

  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  final TextEditingController acronym = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    addWordBloc = BlocProvider.of<CollectionsBloc>(context);
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
    return isPopulated;
  }

  // onAddToCollection() {
  //   addWordBloc.add(AddWordToCollection());
  // }

  void onAddWord() async {
    if (isLoadWordButtonEnabled()) {
      WordModel wordModel = WordModel(
        id: "",
        audio: "",
        definition: definition.text,
        acronym: acronym.text,
        partOfSpeech: "",
        note: note.text,
        word: word.text,
      );
      addWordBloc.add(AddWord(word: wordModel));

      // Clear text field
      // clearTextFields;
    }
  }

  /// Remove collection at selected index
  void _onDismissed(BuildContext context, CollectionModel collection) {
    BlocProvider.of<CollectionsBloc>(context)
        .add(RemoveCartItemModel(collection));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      builder: (context, state) {
        if (state is CollectionsLoading) {
          return UtilDialog.showWaiting(context);
        }
        if (state is CollectionsLoaded) {
          var collections = state.collections;
          return Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultPadding,
              ),
              child: collections.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        return CustomDismissible(
                          key: Key(collections[index] as String),
                          onDismissed: (direction) {
                            _onDismissed(context, collections[index]);
                          },
                          child: CollectionsModelCard(
                            collection: collections[index],
                          ),
                        );
                      })
                  : const Center(
                      child: Text("You have no saved collections"),
                    ));
        }
        if (state is CollectionsLoadFailure) {
          return const Center(
            child: Text("Load failure"),
          );
        }
        return const Center(
          child: Text("Something went wrong."),
        );
      },
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

  _buildTextFieldAcronym() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: acronym,
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
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.multiline,
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

  _buildButtonAddWord() {
    return IconButton(
      onPressed: onAddWord,
      icon: const Icon(CupertinoIcons.arrow_right),
    );
  }
}
