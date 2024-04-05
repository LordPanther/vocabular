import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/collections/bloc/collections_bloc.dart';
import 'package:vocab_app/presentation/screens/collections/bloc/collections_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/bloc.dart';
import 'package:vocab_app/utils/translate.dart';

class CollectionsForm extends StatefulWidget {
  const CollectionsForm({super.key});

  @override
  State<CollectionsForm> createState() => _CollectionsFormState();
}

class _CollectionsFormState extends State<CollectionsForm> {
  late CollectionsBloc collectionsBloc;
  final TextEditingController collection = TextEditingController();
  bool get isCollectionPopulated => collection.text.isNotEmpty;

  @override
  void initState() {
    collectionsBloc = BlocProvider.of<CollectionsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    collection.dispose();
    super.dispose();
  }

  void createCollection(BuildContext context) async {
    if (isCollectionPopulated) {
      CollectionModel collectionModel = CollectionModel(
        name: collection.text,
      );
      collectionsBloc.add(CreateCollection(collection: collectionModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderText("Add new collection..."),
        SizedBox(height: SizeConfig.defaultSize * 5),
        _buildTextFieldCollection(),
        SizedBox(height: SizeConfig.defaultSize * 5),
        _buildButtonProcessAction()
      ],
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

  _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop,
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        IconButton(
          onPressed: () => createCollection(context),
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
