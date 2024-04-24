import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';

class RecordingDialog extends StatelessWidget {
  final VoidCallback onKeep;
  final VoidCallback onDiscard;
  final VoidCallback onPlayAudio;

  const RecordingDialog(
      {super.key,
      required this.onKeep,
      required this.onDiscard,
      required this.onPlayAudio});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
      ),
      title: GestureDetector(
        onTap: onPlayAudio,
        child: const Icon(CupertinoIcons.play),
      ),
      content: const Text('Do you want to keep or discard the recording?'),
      actions: [
        TextButton(
          onPressed: onKeep,
          child: const Text('Keep'),
        ),
        TextButton(
          onPressed: onDiscard,
          child: const Text('Discard'),
        ),
      ],
    );
  }
}
