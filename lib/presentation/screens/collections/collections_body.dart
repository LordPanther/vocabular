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
  final String option;

  const ListCollectionsModel({super.key, required this.option});

  @override
  State<ListCollectionsModel> createState() => _ListCollectionsModelState();
}

class _ListCollectionsModelState extends State<ListCollectionsModel> {
  late CollectionsBloc collectionsBloc;

  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  final TextEditingController collectionId = TextEditingController();
  final TextEditingController collectionName = TextEditingController();

  @override
  void initState() {
    collectionsBloc = BlocProvider.of<CollectionsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    word.dispose();
    definition.dispose();
    super.dispose();
  }

  bool get isPopulated => word.text.isNotEmpty;

  bool isLoadWordButtonEnabled() {
    return isPopulated;
  }

  void addData(String option) async {
    if (isLoadWordButtonEnabled()) {
      CollectionModel collectionModel = CollectionModel(
        name: collectionName.text,
        id: collectionId.text,
      );
      WordModel wordModel = WordModel(
        id: "",
        definition: definition.text,
        word: word.text,
      );
      collectionsBloc.add(
        PopulateCollections(
          option: widget.option,
          collectionModel: collectionModel,
          wordModel: wordModel,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      builder: (context, state) {
        if (state is CollectionsLoading) {
          return UtilDialog.showWaiting(context);
        }
        if (state is CollectionsLoaded) {
          var userOption = widget.option;
          return userOption == "word"
              ? Column(
                  children: [
                    _buildHeaderText(userOption),
                    _buildTextFieldWord(),
                    _buildTextFieldDefinition(),
                    _buildButtonAddWord()
                  ],
                )
              : Column(
                  children: [
                    _buildHeaderText(userOption),
                    _buildTextFieldId(),
                    _buildTextFieldCollection(),
                    _buildButtonAddWord()
                  ],
                );
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

  /// Header text
  _buildHeaderText(String userOption) {
    return Center(
      child: Text(
        Translate.of(context).translate(userOption),
        style: FONT_CONST.BOLD_DEFAULT_16,
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

  /// Collection id
  _buildTextFieldId() {
    return TextFormField(
      style: TextStyle(
          color: COLOR_CONST.textColor, fontSize: SizeConfig.defaultSize * 1.6),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: collectionId,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: Translate.of(context).translate('collection_id'),
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
      controller: collectionName,
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

  _buildButtonAddWord() {
    return IconButton(
      onPressed: () {
        addData(widget.option);
      },
      icon: const Icon(CupertinoIcons.arrow_right),
    );
  }
}
