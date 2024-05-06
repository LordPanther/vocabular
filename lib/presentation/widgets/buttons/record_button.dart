// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/utils.dart';

class RecordButton extends StatefulWidget {
  final User user;
  const RecordButton({super.key, required this.user});

  @override
  State<RecordButton> createState() => RecordButtonState();
}

class RecordButtonState extends State<RecordButton> {
  final _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  String? _path = "";
  Uint8List? _bytes;
  Uint8List? get fileData => _bytes;
  String? get path => _path;

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      bool openSettings = await UtilDialog.showPermissionDialog(
        context: context,
        title: Translate.of(context).translate('permission_denied'),
        content: Translate.of(context).translate('microphone_permission'),
      );
      if (openSettings) openAppSettings();
    }

    await _recorder.openRecorder();

    _isRecorderReady = true;

    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  void onRecord() async {
    if (!widget.user.isAnonymous) {
      if (_isRecording) {
        await stop();
      } else {
        await record();
      }
      setState(() {});
    } else {
      bool signUp = await UtilDialog.showGuestDialog(
          context: context, content: Translate.of(context).translate('switch'));

      if (signUp) {
        Navigator.of(context).pushNamed(AppRouter.SWITCH_USER);
      }
    }
  }

  Future<String> getRecordingPath() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String recordingPath = '${appDocumentsDir.path}/tempRecording';
    // Check if the file already exists
    final existingFile = File(recordingPath);
    if (existingFile.existsSync()) {
      // If the file exists, delete it
      existingFile.deleteSync();
    }
    return recordingPath;
  }

  Future<Uint8List?> getUint8ListFromLocalPath(String? localPath) async {
    if (localPath == null || localPath.isEmpty) {
      return null;
    }
    try {
      final file = File(localPath);
      return await file.readAsBytes();
    } catch (error) {
      if (kDebugMode) {
        print('Error reading file: $error');
      }
      return null;
    }
  }

  Future record() async {
    final String customPath = await getRecordingPath();
    try {
      await _recorder.startRecorder(toFile: customPath);
      setState(() {
        _isRecording = true;
      });
    } on Exception catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
      return;
    }
  }

  Future stop() async {
    if (!_isRecorderReady) return;
    final path = await _recorder.stopRecorder();
    _path = path;
    _isRecording = false;

    Uint8List? bytes = await getUint8ListFromLocalPath(path);
    _bytes = bytes;

    // Show the dialog to keep or discard the recording
    bool keepRecording = await showKeepDiscardDialog();
    if (keepRecording) {
      //Logic to keep the recording
      UtilSnackBar.showSnackBarContent(context, content: "Recording saved");
    } else {
      // Logic to delete the recording or handle as discarded
      final tempFile = File(path!);
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
      UtilSnackBar.showSnackBarContent(context, content: "Recording Discarded");
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          style: const ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            backgroundColor:
                MaterialStatePropertyAll(COLOR_CONST.backgroundColor),
          ),
          onPressed: onRecord,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.defaultSize * 4,
                height: SizeConfig.defaultSize * 4,
                decoration: BoxDecoration(
                  color: _isRecording
                      ? COLOR_CONST.activeColor
                      : COLOR_CONST
                          .primaryColor, // Background color of the Container
                  borderRadius: BorderRadius.circular(
                      SizeConfig.defaultSize * 3), // Rounded corners
                ),
                child: Icon(
                  _isRecording ? CupertinoIcons.stop : CupertinoIcons.mic,
                  size: 25,
                ),
              ),
              SizedBox(width: SizeConfig.defaultSize * 1.5),
              StreamBuilder(
                stream: _recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');
                  final twoDigitsMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return _isRecording
                      ? Text(
                          "$twoDigitsMinutes:$twoDigitSeconds",
                          style: FONT_CONST.BOLD_DEFAULT_16,
                        )
                      : const Text("00:00");
                },
              ),
            ],
          )),
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
              title: PlayButton(
                audioUrl: _path!,
                playMode: "recording",
              ),
              // content:
              //     const Text('Do you want to keep or discard the recording?'),
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
