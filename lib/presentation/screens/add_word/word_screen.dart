import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/word_body.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/word_header.dart';

class WordScreen extends StatefulWidget {
  final WordModel? word;
  const WordScreen({super.key, this.word});

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordBloc()..add(LoadWordScreen()),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const WordHeader(),
                        WordBody(word: widget.word),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
