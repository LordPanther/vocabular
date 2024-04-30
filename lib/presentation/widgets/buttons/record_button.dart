// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/utils.dart';

class RecordButton extends StatefulWidget {
  final Function(String filePath) onRecordingChanged;
  const RecordButton({super.key, required this.onRecordingChanged});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  String _filePath = "";

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
    if (_isRecording) {
      await stop();
    } else {
      await record();
    }
    setState(() {});
  }

  Future record() async {
    if (!_isRecorderReady) return;
    await _recorder.startRecorder(toFile: "audio");
    _isRecording = true;

    setState(() {});
  }

  Future stop() async {
    if (!_isRecorderReady) return;
    final path = await _recorder.stopRecorder();
    _filePath = path!;
    _isRecording = false;

    // Show the dialog to keep or discard the recording
    bool keepRecording = await showKeepDiscardDialog();
    if (keepRecording) {
      //Logic to keep the recording
      widget.onRecordingChanged(_filePath);

      UtilSnackBar.showSnackBarContent(context, content: "Recording saved");
    } else {
      // Logic to delete the recording or handle as discarded
      File(_filePath).delete();
      _filePath = "";
      UtilSnackBar.showSnackBarContent(context, content: "Recording deleted");
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
                audioUrl: _filePath,
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
