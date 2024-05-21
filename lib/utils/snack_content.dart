import 'package:flutter/material.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class SnackContent {
  static void showCheckFlag(BuildContext context, String check) {
    var content = Translate.of(context).translate(check);
    UtilSnackBar.showSnackBarContent(
      context,
      content: content,
    );
  }
}
