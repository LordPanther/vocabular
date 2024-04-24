import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/buttons/record_button.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/presentation/widgets/others/recording_dialog.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:record/record.dart';

class WordBody extends StatefulWidget {
  const WordBody({super.key});

  @override
  State<WordBody> createState() => _WordBodyState();
}

class _WordBodyState extends State<WordBody> {
  late WordBloc wordBloc;
  late AudioPlayer audioPlayer;
  late Timer _timer;
  late Record audioRecord;
  final AuthRepository _authRepository = AppRepository.authRepository;
  final StorageRepository _storageRepository = AppRepository.storageRepository;

  // Controllers/word
  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  String? collection;
  bool isShared = false;

  // Audio recording global variables
  double _progress = 0.0;
  bool _isRecording = false;
  // bool _isPlaying = false;
  String? _audioPath = '';

  @override
  void initState() {
    super.initState();
    wordBloc = BlocProvider.of<WordBloc>(context);
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  void record() {
    setState(() {
      _isRecording = !_isRecording; // Toggle _isLoading state
      _isRecording
          ? _startRecording()
          : _stopRecording(); // Start or stop loading accordingly
    });
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _progress = 0.0;
    });

    const duration = Duration(minutes: 1); // Set duration to one minute
    const steps = 60;

    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
      }
    } catch (error) {
      print(error);
    }

    _timer = Timer.periodic(
      duration ~/ steps, // Calculate the interval for each step
      (timer) {
        if (_progress < 1.0) {
          setState(() {
            _progress += 1 / steps; // Increment progress by a small fraction
          });
        } else {
          _timer.cancel();
          _stopRecording();
        }
      },
    );
  }

  // Show popup upon stop recording
  Future<void> _stopRecording() async {
    String? recordedFilePath = "";
    recordedFilePath = await audioRecord.stop();
    setState(() {
      _timer.cancel();
      _isRecording = false;
      _progress = 0.0;
      _audioPath = recordedFilePath;
    });
    _showRecordingDialog(_audioPath);
  }

  void _showRecordingDialog(String? recordedFilePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return RecordingDialog(
          onKeep: () {
            _audioPath = recordedFilePath;
            Navigator.of(context).pop();
          },
          onDiscard: () async {
            if (_audioPath != null) {
              File localFile = File(_audioPath!);
              if (await localFile.exists()) {
                await localFile.delete();
                Navigator.of(context).pop();
                UtilSnackBar.showSnackBarContent(context,
                    content: "Deleted audio file");
              }
            }
          },
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
    );
  }

  // Future<void> _playRecording() async {
  //   try {
  //     Source urlSource = UrlSource(_audioPath!);
  //     await audioPlayer.play(urlSource);
  //   } catch (error) {
  //     UtilSnackBar.showSnackBarContent(context,
  //         content: "Failed to play recording. retry");
  //     _isPlaying = false;
  //   }
  // }

  bool get isWordPopulated => word.text.isNotEmpty;
  bool get isDefinitionPopulated => definition.text.isNotEmpty;

  void onAddWord() async {
    File? audioFile = File(_audioPath!);
    User? user = _authRepository.loggedFirebaseUser;
    if (isWordPopulated && isDefinitionPopulated && collection != null) {
      String audioUrl = await _storageRepository.uploadAudioFile(
        "vocabusers/audio/${user.uid}/$collection/$word",
        audioFile,
      );
      var newWord = WordModel(
          id: collection!,
          definition: definition.text,
          word: word.text,
          audioUrl: audioUrl);
      var newCollection = CollectionModel(name: collection!);
      wordBloc.add(AddWord(
          collection: newCollection,
          word: newWord,
          share: isShared));
      print("Word added successfully");
      // BlocProvider.of<HomeBloc>(context).add(LoadHome());
      // Navigator.popAndPushNamed(context, AppRouter.HOME);
    } else {
      if (!isWordPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("word_checker"));
      }
      if (!isDefinitionPopulated) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("definition_checker"));
      }
      if (collection == null) {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("collection_checker"));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    word.dispose();
    definition.dispose();
    _timer.cancel();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordBloc, WordState>(
      listener: (context, state) {
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
                  _buildTextFieldWithRecordButton(),
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
            return Center(
              child: Text(Translate.of(context).translate("error_three")),
            );
          }
          return Center(
            child: Text(Translate.of(context).translate("error_one")),
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
      controller: word,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: Translate.of(context).translate('add_word'),
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

  Widget _buildTextFieldWithRecordButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildTextField(),
          Positioned(
            bottom: SizeConfig.defaultSize * -5,
            right: SizeConfig.defaultSize * 13,
            child: RecordButton(
              progress: _progress,
              isRecording: _isRecording,
              onTap: record,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
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
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: COLOR_CONST.primaryColor),
        ),
      ),
    );
  }

  Widget _buildCollectionDropdown(List<String> collections) {
    return DropdownSelectionList(
      action: Translate.of(context).translate("select_collection"),
      items: collections,
      onItemSelected: (String? selectedItem) {
        setState(
          () {
            collection = selectedItem;
          },
        );
      },
    );
  }

  Widget _buildCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            Translate.of(context).translate("share_word"),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: isShared,
          onChanged: (value) {
            setState(
              () {
                isShared = value!;
              },
            );
          },
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
          icon: Icon(
            CupertinoIcons.arrow_right,
            size: SizeConfig.defaultSize * 3,
          ),
        ),
      ],
    );
  }
}
