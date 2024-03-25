import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';
import 'package:vocab_app/presentation/widgets/others/custom_dismissible.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';
import 'package:vocab_app/utils/dialog.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  /// Adding a new collection to collections/<user_id>/[collection]
  void onAddToCollections() {
    homeBloc.add(const AddToCollection(collection: "workcollection"));
  }

  /// Adding a new word to users collections <collection>/<user_id>/[word]
  onAddWordToCollection() {}

  /// Remove/Delete collection and its content
  void _onDismissed(BuildContext context, CollectionModel collection) {}
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return UtilDialog.showWaiting(context);
          }
          if (state is HomeLoaded) {
            var collections = state.homeResponse.collections;
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultPadding,
              ),
              child: collections.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        return CustomDismissible(
                          key: Key(collections[index] as String),
                          onDismissed: (direction) {
                            _onDismissed(context, collections[index]);
                          },
                          child: CollectionsModelCard(
                            collection: collections[index],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("You have no saved collections"),
                    ),
            );
          }
          if (state is HomeLoadFailure) {
            return const Center(
              child: Text("Load failure"),
            );
          }
          return const Center(
            child: Text("Something went wrong."),
          );
        },
      ),
    );
  }
}
