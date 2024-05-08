// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/utils/utils.dart';

class WordTile extends StatefulWidget {
  final WordModel word;

  const WordTile({super.key, required this.word});

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
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
      onEditWord: onAddRecording,
    );
  }

  void onAddRecording() async {
    // UtilDialog.
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.word.word!, style: FONT_CONST.MEDIUM_DEFAULT_18),
      minVerticalPadding: 5,
      onTap: onViewWord,
    );
  }
}
