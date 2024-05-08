// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/word_tile.dart';
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
        children: _buildWordsList(_words, _collection),
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
            final bool dismiss = await showCollectionRemoveDialog();

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

  Future<bool> showCollectionRemoveDialog() async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
              ),
              title: Text(
                Translate.of(context).translate('confirm_remove_word'),
                style: FONT_CONST.BOLD_DEFAULT_18,
              ),
              content: Text(Translate.of(context).translate('remove_word')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    Translate.of(context).translate('no'),
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    Translate.of(context).translate('yes'),
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
              ],
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4 * animation.value,
                sigmaY: 4 * animation.value,
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ) ??
        false;
  }
}
