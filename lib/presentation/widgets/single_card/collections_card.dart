import 'package:flutter/material.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/utils/translate.dart';

class CollectionsModelCard extends StatelessWidget {
  const CollectionsModelCard({
    super.key,
    required this.collection,
    this.onPressed,
  });

  final CollectionsModel collection;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        Translate.of(context).translate(collection.collection).toUpperCase(),
        style: FONT_CONST.BOLD_WHITE_16,
      ),
    );
  }
}
