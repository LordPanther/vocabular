import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/widgets/others/word_tile.dart';

class CollectionTile extends StatelessWidget {
  final CollectionModel collection;
  final int wordsCount;
  final List<WordModel> words;
  final Function onLongPress;

  const CollectionTile({
    super.key,
    required this.collection,
    required this.wordsCount,
    required this.words,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 0.8),
      child: GestureDetector(
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: COLOR_CONST.primaryColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.defaultSize))),
          childrenPadding: EdgeInsets.all(SizeConfig.defaultPadding),
          trailing: const Text(''),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(collection.name[0].toUpperCase() +
                  collection.name.substring(1)),
              Text(wordsCount > 1
                  ? '$wordsCount words'
                  : wordsCount == 1
                      ? '1 word'
                      : ''),
            ],
          ),
          children: _buildWordsList(words),
        ),
        onLongPress: () => onLongPress(),
      ),
    );
  }

  List<Widget> _buildWordsList(List<WordModel> words) {
    return words
        .map(
          (word) => WordTile(word: word),
        )
        .toList();
  }
}
