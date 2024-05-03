// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_event.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class WordTile extends StatefulWidget {
  final WordModel word;

  const WordTile({super.key, required this.word});

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  bool _isPlaying = false;
  String _audioUrl = "";

  @override
  void initState() {
    super.initState();
    print("Audio url ${widget.word.audioUrl}");

    try {
      _audioUrl = widget.word.audioUrl!;
    } catch (e) {
      _audioUrl;
    }
  }

  void removeWord() async {
    bool removeWord = await _showRemoveDialog();
    var collection = CollectionModel(name: widget.word.id);
    var word = widget.word.word != "vocabular";
    if (removeWord) {
      if (word) {
        BlocProvider.of<HomeBloc>(context).add(
          RemoveWord(collection: collection, word: widget.word),
        );
      } else {
        UtilSnackBar.showSnackBarContent(context,
            content: Translate.of(context).translate("default_word"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          if (_audioUrl.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.defaultSize * 2),
              child: PlayButton(
                playMode: "audio",
                audioUrl: _audioUrl,
                onPlayingChanged: (bool isPlaying) {
                  _isPlaying = !isPlaying;

                  setState(() {});
                },
              ),
            ),
          if (!_isPlaying)
            Text(widget.word.word, style: FONT_CONST.MEDIUM_DEFAULT_18),
        ],
      ),
      // subtitle: _wordDefinition(),
      onLongPress: removeWord,
      onTap: () {},
    );
  }

  Widget _wordDefinition() {
    return Text(widget.word.definition, style: FONT_CONST.REGULAR_DEFAULT_18);
  }

  Future<bool> _showRemoveDialog() async {
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
                  Translate.of(context).translate("confirm_remove_word"),
                  style: FONT_CONST.BOLD_DEFAULT_18,
                ),
              ),
              content: Text(Translate.of(context).translate("remove_word")),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(Translate.of(context).translate("no")),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(Translate.of(context).translate("yes")),
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
