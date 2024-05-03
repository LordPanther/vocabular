// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/widgets/others/word_tile.dart';

class CollectionTile extends StatefulWidget {
  final CollectionModel collection;
  final List<WordModel> words;
  final int index;

  const CollectionTile({
    super.key,
    required this.collection,
    required this.words,
    required this.index,
  });

  @override
  State<CollectionTile> createState() => _CollectionTileState();
}

class _CollectionTileState extends State<CollectionTile> {
  late CollectionModel _collection;
  late List<WordModel> _words;

  @override
  void initState() {
    super.initState();
    _collection = widget.collection;
    _words = widget.words;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 0.8),
      child: ExpansionTile(
        key: ValueKey(widget.key),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: COLOR_CONST.primaryColor),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize))),
        childrenPadding: EdgeInsets.all(SizeConfig.defaultPadding),
        trailing: Text(
            _words.length > 1
                ? '${_words.length} words'
                : _words.length == 1
                    ? '1 word'
                    : '',
            style: FONT_CONST.REGULAR_DEFAULT_16),
        title: Text(
            _collection.name![0].toUpperCase() + _collection.name!.substring(1),
            style: FONT_CONST.MEDIUM_DEFAULT_18),
        children: _buildWordsList(_words),
      ),
    );
  }

  List<Widget> _buildWordsList(List<WordModel> words) {
    return words
        .map(
          (word) => WordTile(
            word: word,
          ),
        )
        .toList();
  }
}
