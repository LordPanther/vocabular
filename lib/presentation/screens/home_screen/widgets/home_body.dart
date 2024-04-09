import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/common_blocs/home/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/snackbar.dart';

class HomeBody extends StatefulWidget {
  late final Function(List<CollectionModel>) sendCollections;
  // ignore: prefer_const_constructors_in_immutables
  HomeBody({super.key, required this.sendCollections});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;
  late List<CollectionModel> collections;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize collections when dependencies change
    final state = BlocProvider.of<HomeBloc>(context).state;
    if (state is HomeLoaded) {
      collections = state.homeResponse.collections;
      widget.sendCollections(collections); // Send collections to parent widget
    }
  }

  /// Remove/Delete collection and its content
  onRemoveCollection(CollectionModel collection) {
    homeBloc.add(RemoveCollection(collection));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is CollectionCreated) {
          UtilSnackBar.showSnackBarContent(context,
              content: "Collection created...");
        }
        if (state is CollectionRemoved) {
          UtilSnackBar.showSnackBarContent(context,
              content: "Collection removed...");
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Loading();
          }
          if (state is HomeLoaded) {
            var collections = state.homeResponse.collections;
            var words = state.homeResponse.words;
            return Expanded(
              child: ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  var collection = collections[index];
                  return ExpansionTile(
                    title: Text(collection.name),
                    subtitle: const Text("<word_count>"),
                    trailing: collection.name == "default"
                        ? null
                        : IconButton(
                            onPressed: () => onRemoveCollection(collection),
                            icon: const Icon(CupertinoIcons.minus),
                          ),
                    children: _buildWordsList(words[index]),
                  );
                },
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

  List<Widget> _buildWordsList(List<WordModel> words) {
    List<Widget> wordTiles = [];
    for (var word in words) {
      wordTiles.add(
        ListTile(
          title: Text(word.word),
          subtitle: Text(word.definition),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Removal"),
                  content:
                      const Text("Are you sure you want to remove this word?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Dispatch remove word event here
                        homeBloc.add(RemoveWord(
                            collection: CollectionModel(
                              name: word.id,
                            ),
                            word: word));
                        Navigator.of(context).pop();
                      },
                      child: const Text("Remove"),
                    ),
                  ],
                );
              },
            );
          },
          // Add any other widgets related to the word
        ),
      );
    }
    return wordTiles;
  }
}
