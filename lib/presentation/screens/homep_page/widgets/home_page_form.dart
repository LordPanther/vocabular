import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/add_word/add_word_screen.dart';
import 'package:vocab_app/presentation/screens/home_screen/home_screen.dart';
import 'package:vocab_app/presentation/screens/homep_page/bloc/home_page_bloc.dart';
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home_screen.dart';
import 'package:vocab_app/presentation/screens/homep_page/bloc/home_page_bloc.dart';
import 'package:vocab_app/presentation/screens/homep_page/bloc/home_page_event.dart';
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)
import 'package:vocab_app/presentation/screens/search/search_screen.dart';
import 'package:vocab_app/presentation/widgets/others/custom_bottom_navigation.dart';

class HomePageForm extends StatefulWidget {
  const HomePageForm({super.key});

  @override
  State<HomePageForm> createState() => _HomePageFormState();
}

class _HomePageFormState extends State<HomePageForm> {
  late HomePageBloc homePageBloc;
  int _currentIndex = 1;

<<<<<<< HEAD
=======
  final formKey = GlobalKey<FormState>();
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)
  final TextEditingController word = TextEditingController();
  final TextEditingController definition = TextEditingController();
  final TextEditingController acronym = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    word.dispose();
    definition.dispose();
    acronym.dispose();
    note.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  bool get isPopulated =>
      word.text.isNotEmpty;
=======
  bool get isPopulated => word.text.isNotEmpty;
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)

  bool isLoadWordButtonEnabled() {
    return homePageBloc.state.isFormValid &&
        !homePageBloc.state.isSubmitting &&
        isPopulated;
  }

  void onLoadWord() {
<<<<<<< HEAD
    if(isLoadWordButtonEnabled()) {
      homePageBloc.add(LoadW)
=======
    if (formKey.currentState!.validate()) {
      WordModel wordModel = WordModel(
        id: "",
        audio: "",
        definition: definition.text,
        acronym: acronym.text,
        partOfSpeech: "",
        note: note.text,
        word: word.text,
      );

      if (isLoadWordButtonEnabled()) {
        homePageBloc.add(LoadWord(word: wordModel));
      }
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [
              SearchScreen(),
              HomeScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });

                if (index == 2) {
                  showPopupDialog(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void showPopupDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        TextEditingController textController = TextEditingController();

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter text',
                      ),
                      autocorrect: true,
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    IconButton(
                      onPressed: onLoadWord,
                      icon: const Icon(CupertinoIcons.arrow_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    );
  }
}
