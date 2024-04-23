import 'package:flutter/material.dart';

class RecordingDialog extends StatelessWidget {
  final VoidCallback onKeep;
  final VoidCallback onDiscard;

  const RecordingDialog({super.key, required this.onKeep, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Recording Options'),
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
