import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/add_collection/bloc/collection_bloc.dart';
import 'package:vocab_app/presentation/screens/add_collection/bloc/collection_event.dart';
import 'package:vocab_app/presentation/screens/add_collection/bloc/collection_state.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_event.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
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
      BlocProvider.of<HomeBloc>(context).add(LoadHome());
    } else {
      UtilSnackBar.showSnackBarContent(context,
          content: "Please add a collection...");
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
              content: "Collection Added...");
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
                  _buildHeaderText("Add new collection..."),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildCollectionTextField(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildCollectionDropdown(collections),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildButtonProcessAction(),
                ],
              ),
            );
          }

          if (state is CollectionAddFailure) {
            return const Center(
              child: Text("Load failure"),
            );
          }
          return const Center(
            child: Text("Something went wrong."),
          );
        },
      ),
    );
  }

  Widget _buildHeaderText(String userOption) {
    return Center(
      child: Text(
        userOption,
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
        labelText: Translate.of(context).translate('add_collection'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: COLOR_CONST.primaryColor,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
        ),
      ),
    );
  }

  Widget _buildCollectionDropdown(List<String> collections) {
    return DropdownSelectionList(
      action: "View your collections",
      items: collections,
      onItemSelected: (String? selecteItem) {},
    );
  }

  Widget _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.xmark,
            size: SizeConfig.defaultSize * 3,
          ),
        ),
        IconButton(
          onPressed: onAddCollection,
          icon: Icon(
            CupertinoIcons.arrow_right,
            size: SizeConfig.defaultSize * 3,
          ),
        ),
      ],
    );
  }
}
