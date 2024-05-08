import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/volume_icon.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';

class UtilDialog {
  static Future<UserModel?> updateUserDetails({
    required BuildContext context,
    required ProfileLoaded state,
  }) async {
    TextEditingController email =
        TextEditingController(text: state.loggedUser.email);
    TextEditingController username =
        TextEditingController(text: state.loggedUser.username);
    TextEditingController firstName =
        TextEditingController(text: state.loggedUser.firstname);
    TextEditingController lastName =
        TextEditingController(text: state.loggedUser.lastname);
    // Add more controllers for other fields as needed

    return await showGeneralDialog<UserModel>(
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
          title: Text(
            Translate.of(context).translate("update_user"),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: COLOR_CONST.textColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLOR_CONST.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: COLOR_CONST.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: COLOR_CONST.textColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLOR_CONST.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: COLOR_CONST.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize),
                TextFormField(
                  controller: firstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: COLOR_CONST.textColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLOR_CONST.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: COLOR_CONST.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize),
                TextFormField(
                  controller: lastName,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: COLOR_CONST.textColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLOR_CONST.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: COLOR_CONST.primaryColor),
                    ),
                  ),
                ),
                // Add more text fields for other fields as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Translate.of(context).translate("cancel"),
                style: FONT_CONST.MEDIUM_DEFAULT_18,
              ),
            ),
            TextButton(
              onPressed: () {
                if (firstName.text.isNotEmpty) {
                  UserModel updatedDetails = UserModel(
                    email: firstName.text,
                    firstname: firstName.text,
                    lastname: lastName.text,
                    username: username.text,
                  );
                  Navigator.of(context).pop(updatedDetails);
                } else {
                  UtilSnackBar.showSnackBarContent(context,
                      content: "Cannot have empty email field");
                }
              },
              child: Text(
                Translate.of(context).translate("update"),
                style: FONT_CONST.MEDIUM_DEFAULT_18,
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

  static Future<bool> showRemoveDialog({
    required BuildContext context,
  }) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                  Translate.of(context).translate("confirm_remove_word"),
                  style: FONT_CONST.BOLD_DEFAULT_18,
                ),
              ),
              content: Text(Translate.of(context).translate("remove_word")),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(Translate.of(context).translate("no")),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(Translate.of(context).translate("yes")),
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
        ) ??
        false;
  }

  static Future<bool> showGuestDialog({
    required BuildContext context,
    required String content,
  }) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content),
                  SizedBox(height: SizeConfig.defaultSize * 3),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(Translate.of(context).translate("sign_up"),
                          style: FONT_CONST.MEDIUM_DEFAULT_18),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    Translate.of(context).translate("close"),
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
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
        ) ??
        false;
  }

  static Future<bool> showPermissionDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
              ),
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Cancel',
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Settings',
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
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
        ) ??
        false;
  }

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
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
          ),
          title: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: const CircularVolumeIcon(),
              ),
              SizedBox(width: SizeConfig.defaultSize * 2),
              Text(word![0].toUpperCase() + word.substring(1),
                  style: FONT_CONST.MEDIUM_DEFAULT_20),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(words[index].definition!),
                SizedBox(height: SizeConfig.defaultSize * 5),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pushNamed(AppRouter.HOME);
                    },
                    child: Text(
                      'Collection: ${words[index].id!.toUpperCase()}',
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Translate.of(context).translate("close"),
                  style: FONT_CONST.MEDIUM_DEFAULT_18),
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

  static showWordDetails(
    BuildContext context, {
    required String? tooltip,
    required WordModel word,
    Function()? onPressed,
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
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
          ),
          title: word.audioUrl != null
              ? Row(
                  children: [
                    PlayButton(
                      audioUrl: word.audioUrl!,
                      playMode: "audio",
                    ),
                    SizedBox(width: SizeConfig.defaultSize * 2),
                    Text(word.word![0].toUpperCase() + word.word!.substring(1),
                        style: FONT_CONST.MEDIUM_DEFAULT_20),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(word.word![0].toUpperCase() + word.word!.substring(1),
                        style: FONT_CONST.MEDIUM_DEFAULT_20),
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(CupertinoIcons.add_circled),
                      tooltip: tooltip,
                    ),
                  ],
                ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(word.definition!),
                SizedBox(height: SizeConfig.defaultSize * 5),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pushNamed(AppRouter.HOME);
                    },
                    child: Text(
                      'Collection: ${word.id!.toUpperCase()}',
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Translate.of(context).translate("close"),
                  style: FONT_CONST.MEDIUM_DEFAULT_18),
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
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
          ),
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
        return const Loading();
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
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.defaultSize)),
          ),
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
