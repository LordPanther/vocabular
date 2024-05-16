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
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/utils.dart';

class RecordButton extends StatefulWidget {
  final User user;
  final ValueChanged<bool>? isRecording;
  const RecordButton(
      {super.key, required this.user, required this.isRecording});

  @override
  State<RecordButton> createState() => RecordButtonState();
}

class RecordButtonState extends State<RecordButton> {
  late FlutterSoundRecorder _recorder;
  bool _isRecorderReady = false;
  bool _isRecording = false;
  String? _path = "";
  Uint8List? _bytes;
  bool _isAnonymous = false;
  late Duration _duration;

  //Getters
  Uint8List? get fileData => _bytes;
  String? get path => _path;

  @override
  void initState() {
    super.initState();

    _recorder = FlutterSoundRecorder();

    _isAnonymous = widget.user.isAnonymous;
    if (!_isAnonymous) {
      initRecorder();
    }
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
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<String> getRecordingPath() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String recordingPath = '${appDocumentsDir.path}/tempRecording';
    final existingFile = File(recordingPath);
    if (existingFile.existsSync()) {
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

  Future<void> startRecording() async {
    final String customPath = await getRecordingPath();
    _duration = Duration.zero;
    try {
      await _recorder.startRecorder(toFile: customPath);
      setState(() {
        _isRecording = true;
        widget.isRecording!(_isRecording);
      });
    } on Exception catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
    }
  }

  Future stopRecording() async {
    if (!_isRecorderReady) return;
    final path = await _recorder.stopRecorder();

    _path = path;
    setState(() {
      _isRecording = false;
      widget.isRecording!(false);
    });

    Uint8List? bytes = await getUint8ListFromLocalPath(path);
    _bytes = bytes;

    bool keepRecording = await showKeepDiscardDialog();
    if (keepRecording) {
      UtilSnackBar.showSnackBarContent(context, content: "Recording saved");
    } else {
      final tempFile = File(path!);
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
      UtilSnackBar.showSnackBarContent(context, content: "Recording Discarded");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _recorder.closeRecorder();
  }

  void onRecord() async {
    if (!widget.user.isAnonymous) {
      if (_isRecording) {
        await stopRecording();
      } else {
        await startRecording();
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onRecord,
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
                size: SizeConfig.defaultSize * 2.5,
              ),
            ),
            SizedBox(width: SizeConfig.defaultSize),
            _isRecording
                ? StreamBuilder(
                    stream: _recorder.onProgress,
                    builder: (context, snapshot) {
                      _duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;

                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final twoDigitsMinutes =
                          twoDigits(_duration.inMinutes.remainder(60));
                      final twoDigitSeconds =
                          twoDigits(_duration.inSeconds.remainder(60));

                      return _isRecording
                          ? Text(
                              "$twoDigitsMinutes:$twoDigitSeconds",
                              style: FONT_CONST.BOLD_DEFAULT_16,
                            )
                          : Container(
                              width: SizeConfig.defaultSize * 4.5,
                              height: SizeConfig.defaultSize * 4.5,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(IMAGE_CONST.AI_LOGO)),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.defaultSize *
                                        3), // Rounded corners
                              ),
                            );
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
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
