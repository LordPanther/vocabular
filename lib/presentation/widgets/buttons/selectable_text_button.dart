import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';

class SelectableTextButtonRow extends StatefulWidget {
  final void Function(String) onTextSelected;

  const SelectableTextButtonRow({super.key, required this.onTextSelected});

  @override
  _SelectableTextButtonRowState createState() =>
      _SelectableTextButtonRowState();
}

class _SelectableTextButtonRowState extends State<SelectableTextButtonRow> {
  String _selectedText = "";

  void _handleTextSelected(String text) {
    setState(() {
      _selectedText = text;
    });
    widget.onTextSelected(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _handleTextSelected("collection"),
          child: Text(
            'Collection',
            style: TextStyle(
              color: _selectedText == "collection"
                  ? COLOR_CONST.primaryColor
                  : COLOR_CONST.textColor,
              fontSize: SizeConfig.defaultSize * 2,
            ),
          ),
        ),
        const SizedBox(width: 16), // Adjust the spacing between buttons
        TextButton(
          onPressed: () => _handleTextSelected("word"),
          child: Text(
            'Word',
            style: TextStyle(
              color: _selectedText == "word"
                  ? COLOR_CONST.primaryColor
                  : COLOR_CONST.textColor,
              fontSize: SizeConfig.defaultSize * 2,
            ),
          ),
        ),
      ],
    );
  }
}
