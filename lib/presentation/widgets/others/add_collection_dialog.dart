import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/common_blocs/home/bloc.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class AddCollectionDialog extends StatefulWidget {
  const AddCollectionDialog({super.key});

  @override
  State<AddCollectionDialog> createState() => _AddCollectionDialogState();
}

class _AddCollectionDialogState extends State<AddCollectionDialog> {
  CollectionsRepository collectionsRepository =
      AppRepository.collectionsRepository;
  late List<String> userCollections;
  final TextEditingController collection = TextEditingController();
  bool get isCollectionPopulated => collection.text.isNotEmpty;
  bool collectionExists = false;

  @override
  void initState() {
    userCollections = [];
    fetchCollections();
    super.initState();
  }

  Future<void> fetchCollections() async {
    var collectionData = await collectionsRepository.fetchCollections();
    List<CollectionModel> passedCollections = collectionData.collections;
    userCollections =
        passedCollections.map((collection) => collection.name).toList();
  }

  @override
  void dispose() {
    collection.dispose();
    super.dispose();
  }

  void onCreateCollection() async {
    if (isCollectionPopulated) {
      if (!userCollections.contains(collection.text)) {
        CollectionModel collectionModel = CollectionModel(
          name: collection.text,
        );
        await collectionsRepository.createCollection(collectionModel);
        Navigator.of(context).popAndPushNamed(AppRouter.HOME);
      } else {
        setState(() {
          collectionExists = true;
        });
      }
    } else {
      UtilSnackBar.showSnackBarContent(context,
          content: "Enter collection first...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderText("Add new collection..."),
          SizedBox(height: SizeConfig.defaultSize * 5),
          _buildTextFieldCollection(),
          SizedBox(height: SizeConfig.defaultSize * 3),
          _buildCollectionExists(),
          SizedBox(height: SizeConfig.defaultSize * 5),
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

  _buildCollectionExists() {
    return collectionExists
        ? Center(
            child: Text(
              "Collection already exists",
              style: FONT_CONST.BOLD_PRIMARY_18,
            ),
          )
        : const Text("");
  }

  _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        IconButton(
          onPressed: onCreateCollection,
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}