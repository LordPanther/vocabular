// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/collection_tile.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
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
            var collections = state.homeResponse.collections;
            var wordss = state.homeResponse.words;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.defaultPadding),
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
                    var words = wordss[index];
                    return CollectionTile(
                        collection: collection, words: words, index: index);
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
}
