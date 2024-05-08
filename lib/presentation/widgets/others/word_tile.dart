// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
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
import 'package:vocab_app/utils/utils.dart';

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
    if (kDebugMode) {
      print("Audio url ${widget.word.audioUrl}");
    }

    try {
      _audioUrl = widget.word.audioUrl!;
    } catch (e) {
      _audioUrl;
    }
  }

  void onViewWord() async {
    UtilDialog.showWordDetails(
      context,
      word: widget.word,
      tooltip: "Add audio definition",
      onPressed: () {},
    );
  }

  void removeWord() async {
    bool removeWord = await UtilDialog.showRemoveDialog(context: context);
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
            Text(widget.word.word!, style: FONT_CONST.MEDIUM_DEFAULT_18),
        ],
      ),
      // subtitle: _wordDefinition(),
      onLongPress: removeWord,
      onTap: onViewWord,
    );
  }
}
