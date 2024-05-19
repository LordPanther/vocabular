// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/ai/ai_service.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/word/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/buttons/ai_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/audio_manager.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/initializer.dart';
import 'package:vocab_app/presentation/widgets/others/my_text_field.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/snack_content.dart';
import 'package:vocab_app/utils/translate.dart';

class WordBody extends StatefulWidget {
  final WordModel? word;
  const WordBody({super.key, this.word});

  @override
  State<WordBody> createState() => _WordBodyState();
}

class _WordBodyState extends State<WordBody> {
  late WordBloc wordBloc;
  late WordModel word;
  late WordModel oldWord;
  late CollectionModel collection;
  final AIService aiService = AIService();
  final AudioManager audioManager = AudioManager();
  final recordButtonState = GlobalKey<RecordButtonState>();
  final AuthRepository _authRepository = AppRepository.authRepository;

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
        audioUrl: widget.word!.audioUrl ?? "",
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

  void _onAddWord() async {
    if (_isGenerating) {
      SnackContent.getGeneratorError(context);
      return;
    }
    if (!isWordPopulated) {
      SnackContent.getWordError(context);
      return;
    }
    if (!isDefinitionPopulated && !isAudioRecorded) {
      SnackContent.getDefinitionError(context);
      return;
    }
    if (!isCollectionPopulated) {
      SnackContent.getCollectionError(context);
      return;
    }

    String timeStamp = "${DateTime.now().millisecondsSinceEpoch}";
    try {
      if (isAudioRecorded) {
        _audioUrl =
            await audioManager.uploadAudioData(user, timeStamp, _audioUrl);
      }

      var newWord = await WordsManager.instantiateModels(
        _collection,
        _word.text,
        _definition.text,
        _audioUrl,
        timeStamp,
        _isShared,
      );

      if (_isEditing) {
        wordBloc.add(UpdateWord(updatedWord: newWord, oldWord: oldWord));
      } else {
        wordBloc.add(AddWord(word: newWord, isEditing: _isEditing));
      }

      _cleanupRecordingFile();
    } catch (e) {
      UtilDialog.showInformation(context, content: e.toString());
    }
  }

  void _cleanupRecordingFile() {
    final tempFile = File(recordButtonState.currentState?.path ?? '');
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }
  }

  void fetchAiResponse() async {
    if (!isWordPopulated) {
      UtilSnackBar.showSnackBarContent(context,
          content: "Please enter a word first...");
      return;
    }

    if (!_isGenerating) {
      setState(() {
        _isGenerating = true;
      });

      String response = await aiService.getAiResponse(_word);

      if (response == "error") {
        _definition.text = "Gemini could not generate response";
      } else {
        _definition.text = response;
      }

      setState(() {
        _isGenerating = false;
      });
    } else {
      bool keepRecording =
          await UtilDialog.showKeepDiscardDialog(context: context);
      if (!keepRecording) {
        _definition.clear();
      }
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  void dispose() {
    _word.dispose();
    _definition.dispose();
    super.dispose();
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
            color: COLOR_CONST.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
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
          MyTextField(controller: _definition),
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
          onPressed: _onAddWord,
          buttonName: _isEditing
              ? Translate.of(context).translate('update_word')
              : Translate.of(context).translate('add_word'),
          buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
        ),
      ],
    );
  }
}
