import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_event.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class WordTile extends StatelessWidget {
  final WordModel word;

  const WordTile({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.word, style: FONT_CONST.BOLD_BLACK_16),
      subtitle: Text(word.definition),
      onLongPress: () => _showRemoveDialog(context),
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
              Translate.of(context).translate("confirmation"),
              style: FONT_CONST.BOLD_DEFAULT_18,
            ),
          ),
          content: Text(Translate.of(context).translate("word_remove")),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.xmark),
            ),
            IconButton(
              onPressed: () {
                // Dispatch remove word event here
                if (word.word != "vocabular") {
                  context.watch<HomeBloc>().add(RemoveWord(
                      collection: CollectionModel(
                        name: word.id,
                      ),
                      word: word));
                } else {
                  UtilSnackBar.showSnackBarContent(context,
                      content: Translate.of(context).translate("content_one"));
                }

                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.arrow_right),
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
    );
  }
}
