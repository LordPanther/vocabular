import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';

class DropdownSelectionList extends StatefulWidget {
  final List<String> items;
  final String action;
  final void Function(String?) onItemSelected;

  const DropdownSelectionList(
      {super.key, required this.action, required this.items, required this.onItemSelected});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownSelectionListState createState() => _DropdownSelectionListState();
}

class _DropdownSelectionListState extends State<DropdownSelectionList> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      hint: Padding(
        padding: EdgeInsets.only(right: SizeConfig.defaultSize * 3),
        child: Text(widget.action),
      ),
      icon: const Icon(CupertinoIcons.chevron_down),
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
          child: Center(child: Text(value.toUpperCase())),
        );
      }).toList(),
    );
  }
}
