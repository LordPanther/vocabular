// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/word_tile.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

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
  final List<WordModel> _words = [];

  @override
  void initState() {
    super.initState();
    _collection = widget.collection;
    getWords();
  }

  void getWords() {
    var words = widget.words;
    for (var word in words) {
      if (word.id == _collection.name) {
        _words.add(word);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.defaultSize * 1.5,
        right: SizeConfig.defaultSize * 1.5,
        bottom: SizeConfig.defaultSize * 1.5,
      ),
      child: Card(
        color: COLOR_CONST.primaryColor,
        elevation: SizeConfig.defaultSize * .5,
        shape: RoundedRectangleBorder(
          // Set rounded borders
          borderRadius: BorderRadius.circular(5),
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle.noAnimation,
          key: ValueKey(widget.key),
          childrenPadding: EdgeInsets.all(SizeConfig.defaultPadding),
          trailing: Text(
              _words.length > 1
                  ? '${_words.length} words'
                  : _words.length == 1
                      ? '1 word'
                      : '',
              style: FONT_CONST.REGULAR_DEFAULT_16),
          title: Text(
              _collection.name![0].toUpperCase() +
                  _collection.name!.substring(1),
              style: FONT_CONST.MEDIUM_DEFAULT_18),
          children: _buildWordsList(_words, _collection),
        ),
      ),
    );
  }

  List<Widget> _buildWordsList(
      List<WordModel> words, CollectionModel collection) {
    return words.map((word) {
      return Dismissible(
        key: ValueKey(word
            .word), // Ensure you have a unique identifier, `id` in this case
        direction: DismissDirection.endToStart, // Set the direction of dismiss
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final bool dismiss =
                await UtilDialog.showCollectionRemoveDialog(context: context);

            if (dismiss && word.word != "vocabular") {
              BlocProvider.of<HomeBloc>(context)
                  .add(RemoveWord(collection: collection, word: word));
              words.remove(word);
              return dismiss;
            } else {
              UtilSnackBar.showSnackBarContent(context,
                  content: Translate.of(context).translate("default_word"));
            }
            return false;
          }
          return null;
        },
        background: Container(
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 20),
            ],
          ),
        ),
        child: WordTile(
          word: word,
        ),
      );
    }).toList();
  }
}
