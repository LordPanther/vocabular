import 'dart:ui';

import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';

class UtilDialog {
  // static chooseCollection({
  //   required BuildContext context,
  //   required List<CollectionsModel> collections,
  //   required WordModel word,
  // }) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: const Duration(milliseconds: 500),
  //     pageBuilder: (BuildContext context, Animation<double> animation,
  //         Animation<double> secondaryAnimation) {

  //       return AlertDialog(
  //         backgroundColor: Colors.transparent,
  //         content: BlocConsumer<CollectionsBloc, CollectionsState>(
  //           listener: (context, state) {
  //           },
  //           builder: (context, sate) {
  //             return Stack(
  //           children: <Widget>[
  //             Container(
  //               width: double.maxFinite,
  //               padding: const EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: collections.isNotEmpty
  //                   ? ListView.builder(
  //                       shrinkWrap: true,
  //                       itemCount: collections.length,
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return RadioListTile(
  //                           title: const Text("Select collection"),
  //                           value: index,
  //                           groupValue: context.read<CollectionsBloc>().isSelectedIndex,
  //                           onChanged: ((int? value) {
  //                             context.read<CollectionsBloc>().add(ItemSelected(index));
  //                           }),
  //                         );
  //                       })
  //                   : IconButton(
  //                       onPressed: onPressed,
  //                       icon: const Icon(CupertinoIcons.add_circled),
  //                       tooltip: "Create new collection",
  //                     ),
  //             ),
  //           ],
  //         ),
  //         ),
  //         actions: <Widget>[
  //           IconButton(
  //               onPressed: onIconTapped,
  //               icon: const Icon(CupertinoIcons.arrow_right))
  //         ],
  //       );
  //     },
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(
  //           sigmaX: 4 * animation.value,
  //           sigmaY: 4 * animation.value,
  //         ),
  //         child: FadeTransition(
  //           opacity: animation,
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }

  static showCustomContent(
    BuildContext context, {
    String? content,
    Function()? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        // var state = context.watch<RegisterBloc>().state;

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
    );
  }

  static showInformation(
    BuildContext context, {
    String? title,
    String? content,
    Function()? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) {
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
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
    );
  }
}
