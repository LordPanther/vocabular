import 'package:flutter/material.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class SnackContent {
  static SnackBar getGeneratorError(BuildContext context) {
    return UtilSnackBar.showSnackBarContent(context,
        content: Translate.of(context).translate("ai_checker"));
  }

  static SnackBar getWordError(BuildContext context) {
    return UtilSnackBar.showSnackBarContent(context,
        content: Translate.of(context).translate("word_checker"));
  }

  static SnackBar getDefinitionError(BuildContext context) {
    return UtilSnackBar.showSnackBarContent(context,
        content: Translate.of(context).translate("definition_checker"));
  }

  static SnackBar getCollectionError(BuildContext context) {
    return UtilSnackBar.showSnackBarContent(context,
        content: Translate.of(context).translate("collection_checker"));
  }

  static SnackBar getAudioError(BuildContext context) {
    return UtilSnackBar.showSnackBarContent(context,
        content: Translate.of(context).translate("audio_checker"));
  }
}
