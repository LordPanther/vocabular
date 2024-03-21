import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/add_word_form.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/add_word_bloc.dart';
import 'package:vocab_app/presentation/screens/add_word/widgets/add_word_header.dart';

class AddWordScreen extends StatelessWidget {
  const AddWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddWordBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                AddWordHeader(),
                AddWordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
