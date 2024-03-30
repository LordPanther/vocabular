import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionDialog extends StatelessWidget {
  const SelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedOption = ""; // Variable to hold the selected option

    return AlertDialog(
      title: const Text('Add new...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Option
          ListTile(
            title: const Text('Collection'),
            onTap: () {
              selectedOption = 'collection';
            },
          ),
          // Second Option
          ListTile(
            title: const Text('Word'),
            onTap: () {
              selectedOption = 'word';
            },
          ),
        ],
      ),
      actions: <Widget>[
        // Enter
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),

        IconButton(
          onPressed: () {
            Navigator.of(context).pop(selectedOption); // Close the dialog
          },
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
