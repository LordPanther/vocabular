import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/widgets/others/dropdown_list.dart';

class SelectionDialog extends StatefulWidget {
  final List<CollectionModel> collections;
  const SelectionDialog({super.key, required this.collections});

  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  // Variable to hold the selected option
  String selectedOption = "";
  String? collectionOption = "";
  List<String> dropdownCollection = [];

  onSelection(List<CollectionModel> collections) {
    selectedOption = 'word';
    for (var collection in collections) {
      dropdownCollection.add(collection.name);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          selectedOption == "word"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
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
                      onTap: () => onSelection(widget.collections),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const Text("Choose collection"),
                    const SizedBox(height: 5),
                    DropdownSelectionList(
                      items: dropdownCollection,
                      onItemSelected: (String? selectedItem) {
                        collectionOption = selectedItem;
                      },
                    ),
                  ],
                )
        ],
      ),
      actions: <Widget>[
        // Enter
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.arrow_left),
        ),

        IconButton(
          onPressed: () =>
              Navigator.of(context).pop([selectedOption, collectionOption]),
          icon: const Icon(CupertinoIcons.arrow_right),
        ),
      ],
    );
  }
}
