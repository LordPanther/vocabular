// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/common_blocs/app_settings/bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/presentation/widgets/others/collection_tile.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:vocab_app/utils/utils.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;
  bool? _showRecentWord = false;
  final AuthRepository _authRepository = AppRepository.authRepository;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    showRecentWord();
  }

  void showRecentWord() {
    _showRecentWord = LocalPref.getBool("showRecentWord") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, settingState) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(),
                    ],
                  ),
                ),
              );
            }
            if (state is HomeLoaded) {
              var collections = state.homeResponse.collections;
              var words = state.homeResponse.words;
              var recentWord = state.homeResponse.recentWord;
              _showRecentWord = LocalPref.getBool("showRecentWord") ?? false;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.defaultPadding),
                  child: Column(
                    children: [
                      _authRepository.currentUser.isAnonymous
                          ? const SizedBox.shrink()
                          : _showRecentWord!
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.defaultSize * 2),
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: COLOR_CONST.primaryColor
                                              .withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            SizeConfig.defaultSize * 1.5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (recentWord!
                                                .audioUrl!.isNotEmpty)
                                              PlayButton(
                                                  audioUrl:
                                                      recentWord.audioUrl!,
                                                  playMode: "audio"),
                                            SizedBox(
                                                height: SizeConfig.defaultSize),
                                            Text(
                                                "Word           : ${recentWord.word!}",
                                                style: FONT_CONST
                                                    .MEDIUM_DEFAULT_16),
                                            SizedBox(
                                                height: SizeConfig.defaultSize),
                                            Text(
                                                "Definition   : ${recentWord.definition!}",
                                                style: FONT_CONST
                                                    .MEDIUM_DEFAULT_16),
                                            SizedBox(
                                                height: SizeConfig.defaultSize),
                                            Text(
                                                "Collection  : ${recentWord.id!.toUpperCase()}",
                                                style: FONT_CONST
                                                    .MEDIUM_DEFAULT_16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                      Expanded(
                        child: ReorderableListView.builder(
                          onReorder: ((oldIndex, newIndex) {
                            setState(() {
                              final index =
                                  newIndex > oldIndex ? newIndex - 1 : newIndex;

                              final collection = collections.removeAt(oldIndex);
                              collections.insert(index, collection);
                            });
                          }),
                          itemCount: collections.length,
                          itemBuilder: (context, index) {
                            var collection = collections[index];
                            return Dismissible(
                              key: ValueKey(collection.name),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  final bool dismiss =
                                      await showCollectionRemoveDialog();

                                  if (dismiss && collection.name != "default") {
                                    if (collection.name != "default") {
                                      BlocProvider.of<HomeBloc>(context).add(
                                          RemoveCollection(
                                              collection: collection));
                                      return dismiss;
                                    } else {
                                      UtilSnackBar.showSnackBarContent(context,
                                          content: Translate.of(context)
                                              .translate("default_collection"));
                                    }
                                  }
                                  return false;
                                }
                                return null;
                              },
                              child: CollectionTile(
                                key: ValueKey(collection.name),
                                collection: collection,
                                words: words,
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Expanded(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Translate.of(context).translate("load_failure"),
                  ),
                ],
              )),
            );
          },
        );
      },
    );
  }

  Future<bool> showCollectionRemoveDialog() async {
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
              title: Text(
                Translate.of(context).translate('confirm_remove_collection'),
                style: FONT_CONST.BOLD_DEFAULT_18,
              ),
              content:
                  Text(Translate.of(context).translate('remove_collection')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    Translate.of(context).translate('no'),
                    style: FONT_CONST.MEDIUM_DEFAULT_18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    Translate.of(context).translate('yes'),
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
}
