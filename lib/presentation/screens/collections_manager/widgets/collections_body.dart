import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/bloc.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
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
  final TextEditingController collection = TextEditingController();

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

  bool get isWordPopulated => word.text.isNotEmpty;
  bool get isCollectionPopulated => collection.text.isNotEmpty;

  /// [CollectionsBloc]
  void addData(String option) async {
    if (option == "collection" && isCollectionPopulated) {
      CollectionModel collectionModel = CollectionModel(
        name: collection.text,
        id: collection.text,
      );
      collectionsBloc.add(
        CreateCollection(
          collectionModel: collectionModel,
        ),
      );
    }
    // } else if (option == "word" && isWordPopulated) {
    //   WordModel wordModel = WordModel(
    //     id: "",
    //     definition: definition.text,
    //     word: word.text,
    //   );
    //   collectionsBloc.add(
    //     PopulateWords(
    //       option: option,
    //       wordModel: wordModel,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionsBloc, CollectionsState>(
      listener: (context, state) {
        /// Registering
        if (state is CollectionsLoading) {
          UtilDialog.showWaiting(context);
        }

        /// Success
        if (state is CollectionsLoaded) {
          UtilSnackBar.showSnackBarContent(context,
              content: "Collection created successfully");
          Navigator.pushNamed(context, AppRouter.HOME);
        }

        /// Failure
        if (state is CollectionsLoadFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.error);
        }
      },
      child: BlocBuilder<CollectionsBloc, CollectionsState>(
        builder: (context, state) {
          var userOption = widget.option;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding * 2,
              vertical: SizeConfig.defaultSize * 3,
            ),
            child: Form(
              child: userOption == "word"
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
            ),
          );
        },
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
          onPressed: () {
            addData(widget.option);
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        IconButton(
          onPressed: () {
            addData(widget.option);
          },
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
