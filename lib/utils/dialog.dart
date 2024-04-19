import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/volume_icon.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';

class UtilDialog {
  static showSeadrchDetail(
    BuildContext context, {
    String? content,
    required int index,
    required List<WordModel> words,
    Function()? onTap,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        // Display word details in the popup
        var word = words[index].word;
        return AlertDialog(
          title: Row(
            children: [
              GestureDetector(onTap: onTap,child: const CircularVolumeIcon(),),
              SizedBox(width: SizeConfig.defaultSize * 2),
              Text(word[0].toUpperCase() + word.substring(1)),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(words[index].definition),
                SizedBox(height: SizeConfig.defaultSize * 5),
                Text(
                    'Collection: ${words[index].id[0].toUpperCase() + words[index].id.substring(1)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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

  static showCustomContent(
    BuildContext context, {
    String? content,
    Function()? onClose,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              onPressed: onClose ?? () => Navigator.pop(context),
              child: Center(
                child: Text(
                  Translate.of(context).translate("close"),
                  style: FONT_CONST.MEDIUM_PRIMARY_18,
                ),
              ),
            )
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

  static showInformation(
    BuildContext context, {
    String? title,
    String? content,
    Function()? onClose,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          title: Text(
            title ?? Translate.of(context).translate("message_for_you"),
            style: FONT_CONST.MEDIUM_PRIMARY_20,
          ),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              child: Text(
                Translate.of(context).translate("close"),
                style: FONT_CONST.MEDIUM_PRIMARY_18,
              ),
            )
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

  static showWaiting(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          content: Container(
            height: 150,
            alignment: Alignment.center,
            child: const Loading(),
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

  static hideWaiting(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<bool?> showConfirmation(
    BuildContext context, {
    String? title,
    required Widget content,
    String confirmButtonText = "Yes",
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          title: Text(
            title ?? Translate.of(context).translate("message_for_you"),
            style: FONT_CONST.MEDIUM_PRIMARY_24,
          ),
          content: content,
          actions: <Widget>[
            TextButton(
              child: Text(
                Translate.of(context).translate("close"),
                style: FONT_CONST.MEDIUM_PRIMARY_18,
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                backgroundColor: COLOR_CONST.primaryColor,
              ),
              child: Text(
                confirmButtonText,
                style: FONT_CONST.REGULAR_WHITE_18,
              ),
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

// Template

// showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (BuildContext context, Animation<double> animation,
//           Animation<double> secondaryAnimation) {
// return AlertDialog(
//           content: Text(content!),
//           actions: <Widget>[
//             TextButton(
//               onPressed: onClose ?? () => Navigator.pop(context),
//               child: Center(
//                 child: Text(
//                   Translate.of(context).translate("close"),
//                   style: FONT_CONST.MEDIUM_PRIMARY_18,
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 4 * animation.value,
//             sigmaY: 4 * animation.value,
//           ),
//           child: FadeTransition(
//             opacity: animation,
//             child: child,
//           ),
//         );
//       },
//     );
