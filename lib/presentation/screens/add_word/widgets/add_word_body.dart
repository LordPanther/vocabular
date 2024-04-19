import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/collection_data.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class AddWordBody extends StatefulWidget {
  const AddWordBody({super.key});

  @override
  State<AddWordBody> createState() => _AddWordBodyState();
}

class _AddWordBodyState extends State<AddWordBody> {
  late WordBloc wordBloc;
  CollectionsRepository collectionsRepository =
      AppRepository.collectionsRepository;
  late List<String> dropdownCollection;
  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  String? collection;
  bool isChecked = false;
  double _progress = 0.0;
  bool _isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    wordBloc = BlocProvider.of<WordBloc>(context);
    dropdownCollection = [];
    fetchCollections();
    super.initState();
  }

  void _startLoading() {
    _isLoading = true;
    _progress = 0.0;
    const duration = Duration(minutes: 1); // Set duration to one minute
    const steps = 60; // 60 steps for one minute

    _timer = Timer.periodic(
      duration ~/ steps, // Calculate the interval for each step
      (timer) {
        setState(
          () {
            _progress += 1 / steps; // Increment progress by a small fraction
            if (_progress >= 1.0) {
              _stopLoading();
            }
          },
        );
      },
    );
  }

  void _stopLoading() {
    _timer.cancel();
    _isLoading = false;
    _progress = 0.0;
  }

  void fetchCollections() {
    /// Fetch collections
    wordBloc.add(GetCollections());

    // List<CollectionModel> passedCollections = collectionData.collections;

    // setState(() {
    //   dropdownCollection =
    //       passedCollections.map((collection) => collection.name).toList();
    // });
  }

  bool get isWordPopulated => word.text.isNotEmpty;
  bool get isDefinitionPopulated => definition.text.isNotEmpty;

  void onAddWord() async {
    if (isWordPopulated && isDefinitionPopulated && collection != null) {
      var newWord = WordModel(
        id: collection!,
        definition: definition.text,
        word: word.text,
      );
      var newCollection = CollectionModel(name: collection!);
      wordBloc.add(
          AddWord(collection: newCollection, word: newWord, share: isChecked));
      Navigator.popAndPushNamed(context, AppRouter.HOME);
    } else {
      if (!isWordPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: "Please add a word first...");
      }
      if (!isDefinitionPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: "Please add a definition first...");
      }
      if (collection == null) {
        UtilSnackBar.showSnackBarContent(context,
            content: "Please select a collection...");
      }
    }
  }

  void record() {
    setState(() {
      _isLoading = !_isLoading; // Toggle _isLoading state
      _isLoading
          ? _startLoading()
          : _stopLoading(); // Start or stop loading accordingly
    });
  }

  @override
  void dispose() {
    word.dispose();
    definition.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordBloc, WordState>(
      listener: (context, state) {
        if (state is WordAdded) {
          UtilSnackBar.showSnackBarContent(context, content: "Word Added...");
        }

        if (state is WordAddFailure) {
          UtilDialog.showInformation(context, content: state.error);
        }
      },
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is Initial) {
            return const Loading();
          }
          if (state is CollectionsRecieved) {
            var collections =
                state.collections.map((collection) => collection.name).toList();
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize * 3,
              ),
              child: Column(
                children: [
                  _buildHeaderText("Add new word..."),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildTextFieldWord(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildTextFieldDefinition(),
                  SizedBox(height: SizeConfig.defaultSize * 1),
                  _buildCollectionDropdown(collections),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _buildCheckbox(),
                  SizedBox(height: SizeConfig.defaultSize * 5),
                  _buildButtonProcessAction(),
                ],
              ),
            );
          }
          if (state is CollectionFailure) {
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

  Widget _buildTextFieldWord() {
    return TextFormField(
      style: TextStyle(
        color: COLOR_CONST.textColor,
        fontSize: SizeConfig.defaultSize * 1.6,
      ),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: word,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: Translate.of(context).translate('add_word'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: COLOR_CONST.textColor,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.textColor),
        ),
      ),
    );
  }

  Widget _buildCollectionDropdown(List<String> collections) {
    return DropdownSelectionList(
      items: collections,
      onItemSelected: (String? selectedItem) {
        setState(() {
          collection = selectedItem;
        });
      },
    );
  }

  Widget _buildTextFieldDefinition() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextFormField(
            style: TextStyle(
              color: COLOR_CONST.textColor,
              fontSize: SizeConfig.defaultSize * 1.6,
            ),
            maxLines: 4,
            cursorColor: COLOR_CONST.textColor,
            textInputAction: TextInputAction.next,
            controller: definition,
            autovalidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.defaultSize,
                horizontal: SizeConfig.defaultSize * 1.5,
              ),
              labelText: Translate.of(context).translate('add_definition'),
              labelStyle: const TextStyle(color: COLOR_CONST.textColor),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: COLOR_CONST.textColor),
              ),
            ),
          ),
          Positioned(
            bottom: SizeConfig.defaultSize * -5,
            right: SizeConfig.defaultSize * 13,
            child: RecordButton(
              progress: _progress,
              isRecording: _isLoading,
              onTap: record,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _recordingIndicator() {
  //   if (_isLoading) {
  //     return LinearProgressIndicator(
  //       value: _progress,
  //       backgroundColor: COLOR_CONST.backgroundColor,
  //       valueColor:
  //           const AlwaysStoppedAnimation<Color>(COLOR_CONST.primaryColor),
  //     );
  //   } else {
  //     return const SizedBox(); // Return an empty widget when not recording
  //   }
  // }

  Widget _buildCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "Share this word with other users for free?",
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonProcessAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onAddWord,
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
