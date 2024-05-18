import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';

class DropdownSelectionList extends StatefulWidget {
  final List<String?> items;
  final String action;
  final void Function(String?) onItemSelected;

  const DropdownSelectionList(
      {super.key,
      required this.action,
      required this.items,
      required this.onItemSelected});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownSelectionListState createState() => _DropdownSelectionListState();
}

class _DropdownSelectionListState extends State<DropdownSelectionList> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: COLOR_CONST.grey,
      elevation: 6,
      borderRadius: BorderRadius.circular(5),
      alignment: Alignment.center,
      underline: Container(),
      hint: Text(widget.action),
      icon: Padding(
        padding: EdgeInsets.only(left: SizeConfig.defaultPadding),
        child: const Icon(CupertinoIcons.chevron_down),
      ),
      value: selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue;
        });
        widget.onItemSelected(newValue);
      },
      items: widget.items.map<DropdownMenuItem<String>>((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(child: Text(value!.toUpperCase())),
        );
      }).toList(),
    );
  }
}
