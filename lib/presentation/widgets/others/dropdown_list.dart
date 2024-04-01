import 'package:flutter/material.dart';

class DropdownSelectionList extends StatefulWidget {
  final List<String> items;
  final void Function(String?) onItemSelected;

  const DropdownSelectionList({super.key, required this.items, required this.onItemSelected});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownSelectionListState createState() => _DropdownSelectionListState();
}

class _DropdownSelectionListState extends State<DropdownSelectionList> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue;
        });
        widget.onItemSelected(newValue);
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}