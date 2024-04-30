// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_event.dart';
import 'package:vocab_app/presentation/widgets/others/word_tile.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class CollectionTile extends StatefulWidget {
  final CollectionModel collection;
  final List<WordModel> words;
  final int index;

  const CollectionTile(
      {super.key,
      required this.collection,
      required this.words,
      required this.index});

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

  void onRemoveCollection() async {
    bool removeCollection = await showCollectionRemoveDialog();
    var collectionName = _collection.name;
    if (removeCollection && collectionName != "default") {
      BlocProvider.of<HomeBloc>(context)
          .add(RemoveCollection(collection: widget.collection));
    } else {
      UtilSnackBar.showSnackBarContent(context,
          content: Translate.of(context).translate('content_two'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 0.8),
      child: GestureDetector(
        onLongPress: onRemoveCollection,
        child: ExpansionTile(
          key: ValueKey(_collection.name),
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: COLOR_CONST.primaryColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.defaultSize))),
          childrenPadding: EdgeInsets.all(SizeConfig.defaultPadding),
          trailing: const Text(''),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_collection.name[0].toUpperCase() +
                  _collection.name.substring(1)),
              Text(_words.length > 1
                  ? '${_words.length} words'
                  : _words.length == 1
                      ? '1 word'
                      : ''),
            ],
          ),
          children: _buildWordsList(_words),
        ),
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
              title: Center(
                child: Text(
                  Translate.of(context).translate('confirmation'),
                  style: FONT_CONST.BOLD_DEFAULT_18,
                ),
              ),
              content:
                  Text(Translate.of(context).translate('collection_remove')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Cancel',
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Remove',
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
