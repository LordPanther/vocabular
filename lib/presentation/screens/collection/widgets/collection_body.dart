import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/collection/bloc/collection_bloc.dart';
import 'package:vocab_app/presentation/screens/collection/bloc/collection_event.dart';
import 'package:vocab_app/presentation/screens/collection/bloc/collection_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class AddCollectionBody extends StatefulWidget {
  const AddCollectionBody({super.key});

  @override
  State<AddCollectionBody> createState() => _AddCollectionBodyState();
}

class _AddCollectionBodyState extends State<AddCollectionBody> {
  late CollectionBloc collectionBloc;
  final TextEditingController collection = TextEditingController();

  bool get isCollectionPopulated => collection.text.isNotEmpty;

  void onAddCollection() async {
    if (isCollectionPopulated) {
      var newCollection = CollectionModel(name: collection.text);
      collectionBloc.add(AddCollection(collection: newCollection));
    } else {
      UtilSnackBar.showSnackBarContent(context,
          content: Translate.of(context).translate("enter_collection"));
    }
  }

  @override
  void initState() {
    super.initState();
    collectionBloc = BlocProvider.of<CollectionBloc>(context);
  }

  @override
  void dispose() {
    collection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionBloc, CollectionState>(
      listener: (context, state) {
        if (state is CollectionAdded) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate("collection_added"));
          Navigator.popAndPushNamed(context, AppRouter.HOME,
              arguments: {state.collection});
        }

        if (state is CollectionAddFailure) {
          UtilDialog.showInformation(context, content: state.error);
        }
      },
      child: BlocBuilder<CollectionBloc, CollectionState>(
        buildWhen: (previous, current) {
          return previous != current && current is CollectionsLoaded;
        },
        builder: (context, state) {
          if (state is Initial) {
            return const Loading();
          }

          if (state is CollectionsLoaded) {
            var collections =
                state.collections.map((collection) => collection.name).toList();
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize * 3,
              ),
              child: Column(
                children: [
                  _buildHeaderText(),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildCollectionTextField(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildCollectionDropdown(collections),
                  SizedBox(height: SizeConfig.defaultSize * 7),
                  _buildButtonProcessAction(),
                ],
              ),
            );
          }

          if (state is CollectionAddFailure) {
            return Center(
              child: Text(Translate.of(context).translate("load_failure")),
            );
          }
          return Center(
            child: Text(Translate.of(context).translate("fall_back_error")),
          );
        },
      ),
    );
  }

  Widget _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate("add_new_collection"),
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  Widget _buildCollectionTextField() {
    return TextFormField(
      style: TextStyle(
        color: COLOR_CONST.textColor,
        fontSize: SizeConfig.defaultSize * 1.6,
      ),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: collection,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: Translate.of(context).translate('collection'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: COLOR_CONST.primaryColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildCollectionDropdown(List<String?> collections) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownSelectionList(
          action: Translate.of(context).translate("view_collections"),
          items: collections,
          onItemSelected: (String? selecteItem) {},
        ),
      ],
    );
  }

  Widget _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          buttonName: Translate.of(context).translate('cancel'),
          buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
        ),
        CustomTextButton(
          onPressed: onAddCollection,
          buttonName: Translate.of(context).translate('collection'),
          buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
        ),
      ],
    );
  }
}
