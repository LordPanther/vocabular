// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/utils/utils.dart';

class WordTile extends StatefulWidget {
  final WordModel word;

  const WordTile({super.key, required this.word});

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  final AuthRepository _authRepository = AppRepository.authRepository;

  void onViewWord() async {
    UtilDialog.showWordDetails(
      context,
      isAnonymous: _authRepository.isAnonymous,
      word: widget.word,
      tooltip: "Add audio definition",
      onEditWord: onAddRecording,
    );
  }

  void onAddRecording() async {}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.word.word!, style: FONT_CONST.MEDIUM_DEFAULT_18),
      minVerticalPadding: 5,
      onTap: onViewWord,
    );
  }
}
