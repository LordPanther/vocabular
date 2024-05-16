// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/ai/ai_service.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/buttons/ai_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class WordBody extends StatefulWidget {
  final WordModel? word;
  const WordBody({super.key, this.word});

  @override
  State<WordBody> createState() => _WordBodyState();
}

class _WordBodyState extends State<WordBody> {
  final recordButtonState = GlobalKey<RecordButtonState>();
  final AIService _aiService = AIService();
  late WordBloc wordBloc;
  late WordModel word;
  late WordModel oldWord;
  late CollectionModel collection;
  final AuthRepository _authRepository = AppRepository.authRepository;
  final StorageRepository _storageRepository = AppRepository.storageRepository;

  // Controllers/word
  late TextEditingController _word;
  late TextEditingController _definition;
  String? _collection;
  bool _isShared = false;
  String _audioUrl = "";
  bool _isEditing = false;
  bool _isGenerating = false;
  bool _isRecording = false;

  // Audio recording global variables
  bool get isWordPopulated => _word.text.isNotEmpty;
  bool get isDefinitionPopulated => _definition.text.isNotEmpty;
  bool get isCollectionPopulated => _collection != null;
  bool get isAudioRecorded => _audioUrl.isNotEmpty;
  User? get user => _authRepository.currentUser;

  @override
  void initState() {
    super.initState();

    if (widget.word != null) {
      word = WordModel(
        id: widget.word!.id,
        definition: widget.word!.definition,
        word: widget.word!.word,
        audioUrl: widget.word!.audioUrl,
      );

      oldWord = word;

      _isEditing = true;
      _collection = widget.word!.id;

      _word = TextEditingController(text: word.word);
      _definition = TextEditingController(text: word.definition);
    } else {
      _word = TextEditingController();
      _definition = TextEditingController();
    }

    wordBloc = BlocProvider.of<WordBloc>(context);
  }

  Future<String> storageData(String? timeStamp) async {
    final fileName = "$timeStamp.m4a";
    String directoryPath = "/vocabusers/${user!.uid}";
    final storagePath = "$directoryPath/$fileName";
    return storagePath;
  }

  Future assignDataToModels(String? timeStamp) async {
    word = WordModel(
      id: _collection,
      word: _word.text,
      definition: _definition.text,
      audioUrl: _audioUrl,
      timeStamp: timeStamp!,
      isShared: _isShared,
    );
    collection = CollectionModel(name: _collection);
  }

  void _onAddWord() async {
    String? timeStamp = "${DateTime.now().millisecondsSinceEpoch}";

    if (isWordPopulated && isCollectionPopulated) {
      if (_audioUrl.isNotEmpty) {
        var storagePath = await storageData(timeStamp);
        if (recordButtonState.currentState!.fileData != null) {
          _audioUrl = await _storageRepository.uploadAudioData(
            storagePath,
            recordButtonState.currentState!.fileData!,
          );
        }
      }

      await assignDataToModels(timeStamp);

      var newWord = AddWordModel(word: word, collection: collection);

      if (_isEditing) {
        wordBloc.add(UpdateWord(updatedWord: newWord, oldWord: oldWord));
      } else {
        wordBloc.add(
          AddWord(word: newWord, isEditing: _isEditing),
        );
      }

      final tempFile = File(recordButtonState.currentState!.path!);
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    } else {
      if (!isWordPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("word_checker"));
      }
      if (!isDefinitionPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("definition_checker"));
      }
      if (_collection == null) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("collection_checker"));
      }
    }
  }

  void fetchAiResponse() async {
    String response = "";
    if (!isWordPopulated) {
      UtilSnackBar.showSnackBarContent(context,
          content: "Please enter a word first...");
      return;
    }

    if (!_isGenerating) {
      setState(() {
        _isGenerating = true;
      });

      // Introduce a delay of 1 second
      await Future.delayed(const Duration(seconds: 1));

      // Fetch the AI response asynchronously
      response = await _aiService.getAiResponse(_word);

      // Update the state with the received response
      if (response == "error") {
        setState(() {
          _definition =
              TextEditingController(text: "Gemini could not generate response");
          _isGenerating = false;
        });
      } else {
        setState(() {
          _definition = TextEditingController(text: response);
        });
      }
    } else {
      bool keepRecording = await showKeepDiscardDialog();
      if (!keepRecording) {
        _definition.clear();
        setState(() {
          _isGenerating = false;
        });
      } else {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _word.dispose();
    _definition.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordBloc, WordState>(
      listener: (context, state) {
        if (state is UpdatingWord) {
          UtilDialog.showWaiting(context);
        }

        if (state is WordAdded) {
          UtilSnackBar.showSnackBarContent(context,
              content: Translate.of(context).translate("word_added"));
          Navigator.popAndPushNamed(context, AppRouter.HOME,
              arguments: {state.word});
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
          if (state is Loaded) {
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
                  _buildWordTextField(),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  _builDefinitionTextField(),
                  SizedBox(height: SizeConfig.defaultSize * 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isEditing
                          ? Text(_collection!.toUpperCase())
                          : _buildCollectionDropdown(collections),
                      _buildCheckbox(),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize * 7),
                  _buildButtonProcessAction(),
                ],
              ),
            );
          }
          if (state is CollectionFailure) {
            return Center(
              child: Text(Translate.of(context).translate("load_failure")),
            );
          }
          return const Center(
            child: Loading(),
          );
        },
      ),
    );
  }

  Widget _buildHeaderText() {
    return Center(
      child: Text(
        Translate.of(context).translate("add_new_word"),
        style: FONT_CONST.BOLD_DEFAULT_18,
      ),
    );
  }

  Widget _buildWordTextField() {
    return TextFormField(
      style: TextStyle(
        color: COLOR_CONST.textColor,
        fontSize: SizeConfig.defaultSize * 1.6,
      ),
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: _word,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: Translate.of(context).translate('word'),
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

  Widget _builDefinitionTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildDefinitionWidget(),
          Positioned(
            bottom: SizeConfig.defaultSize * -3,
            right: SizeConfig.defaultSize * 14.5,
            child: Container(
              width: 110,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: COLOR_CONST.backgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isGenerating
                      ? Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          child: const CircularProgressIndicator(),
                        )
                      : RecordButton(
                          key: recordButtonState,
                          user: user!,
                          isRecording: (bool value) {
                            setState(() {
                              _isRecording = value;
                            });
                          },
                        ),
                  _isRecording
                      ? const SizedBox.shrink()
                      : AIButton(
                          onGenerate: fetchAiResponse,
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionWidget() {
    return TextFormField(
      style: TextStyle(
        color: COLOR_CONST.textColor,
        fontSize: SizeConfig.defaultSize * 1.6,
      ),
      minLines: 4,
      maxLines: 10,
      cursorColor: COLOR_CONST.textColor,
      textInputAction: TextInputAction.next,
      controller: _definition,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: SizeConfig.defaultSize,
          horizontal: SizeConfig.defaultSize * 1.5,
        ),
        labelText: Translate.of(context).translate('add_definition'),
        labelStyle: const TextStyle(color: COLOR_CONST.textColor),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: COLOR_CONST.primaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildCollectionDropdown(List<String?> collections) {
    return DropdownSelectionList(
      action: Translate.of(context).translate("select_collection"),
      items: collections,
      onItemSelected: (String? selectedItem) {
        setState(
          () {
            _collection = selectedItem;
          },
        );
      },
    );
  }

  Widget _buildCheckbox() {
    return Row(
      children: [
        Text(
          Translate.of(context).translate("share_word"),
          overflow: TextOverflow.ellipsis,
        ),
        Checkbox(
          value: _isShared,
          onChanged: (value) {
            setState(
              () {
                _isShared = value!;
              },
            );
          },
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
          onPressed: () {
            _onAddWord();
          },
          buttonName: _isEditing
              ? Translate.of(context).translate('update_word')
              : Translate.of(context).translate('add_word'),
          buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
        ),
      ],
    );
  }

  Future<bool> showKeepDiscardDialog() async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
              ),
              content: const Text(
                  "Do you want to keep or discard this AI result/definition?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Keep',
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Discard',
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
              ],
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4 * animation.value,
                sigmaY: 4 * animation.value,
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ) ??
        false;
  }
}
