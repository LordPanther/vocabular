import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/word_bloc.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/add_word_body.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/add_word_header.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordBloc(),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (context) {
              return const Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AddWordHeader(),
                        AddWordBody(),
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
