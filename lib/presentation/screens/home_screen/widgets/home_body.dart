import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/collection_tile.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:vocab_app/utils/utils.dart';

class HomeBody extends StatefulWidget {
  final Function(List<CollectionModel>) sendCollections;

  const HomeBody({super.key, required this.sendCollections});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // Handle state updates
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Loading();
          }
          if (state is HomeLoaded) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.defaultPadding),
                child: ListView.builder(
                  itemCount: state.homeResponse.collections.length,
                  itemBuilder: (context, index) {
                    var collection = state.homeResponse.collections[index];
                    var words = state.homeResponse.words[index];
                    return CollectionTile(
                      collection: collection,
                      wordsCount: words.length,
                      words: words,
                      onLongPress: () =>
                          _showCollectionRemoveDialog(context, collection),
                    );
                  },
                ),
              ),
            );
          }
          return Center(
              child: Text(Translate.of(context).translate("error_three")));
        },
      ),
    );
  }

  void _showCollectionRemoveDialog(
      BuildContext context, CollectionModel collection) {
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
              Translate.of(context).translate('confirmation'),
              style: FONT_CONST.BOLD_DEFAULT_18,
            ),
          ),
          content: Text(Translate.of(context).translate('collection_remove')),
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
                if (collection.name != "default") {
                  homeBloc.add(RemoveCollection(collection: collection));
                } else {
                  UtilSnackBar.showSnackBarContent(context,
                      content: Translate.of(context).translate('content_two'));
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
