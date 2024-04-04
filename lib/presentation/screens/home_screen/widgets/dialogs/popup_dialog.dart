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
  late String selectedOption;
  String? collectionOption;
  List<String> dropdownCollection = [];

  @override
  void initState() {
    super.initState();
    selectedOption = 'word';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new...'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedOption == "collection")
              Column(
                children: [
                  const Text("Choose collection"),
                  const SizedBox(height: 5),
                  DropdownSelectionList(
                    items: dropdownCollection,
                    onItemSelected: (String? selectedItem) {
                      setState(() {
                        collectionOption = selectedItem;
                      });
                    },
                  ),
                ],
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // First Option
                      ListTile(
                        title: const Text('Collection'),
                        onTap: () {
                          setState(() {
                            selectedOption = 'collection';
                            dropdownCollection.clear();
                            for (var collection in widget.collections) {
                              dropdownCollection.add(collection.name);
                            }
                          });
                        },
                      ),
                      // Second Option
                      ListTile(
                        title: const Text('Word'),
                        onTap: () {
                          setState(() {
                            selectedOption = 'word';
                            dropdownCollection.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: <Widget>[
        // Cancel
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Confirm
        TextButton(
          onPressed: () {
            Navigator.of(context).pop([selectedOption, collectionOption]);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
