// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home/bloc/home_event.dart';
import 'package:vocab_app/presentation/widgets/others/collection_tile.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/presentation/widgets/others/snackbar.dart';
import 'package:vocab_app/utils/translate.dart';

class ReOrderableTile extends StatefulWidget {
  final List<WordModel> words;
  final List<CollectionModel> collections;
  const ReOrderableTile({
    super.key,
    required this.words,
    required this.collections,
  });

  @override
  State<ReOrderableTile> createState() => _ReOrderableTileState();
}

class _ReOrderableTileState extends State<ReOrderableTile> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      onReorder: ((oldIndex, newIndex) {
        setState(() {
          final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

          final collection = widget.collections.removeAt(oldIndex);
          widget.collections.insert(index, collection);
        });
      }),
      itemCount: widget.collections.length,
      itemBuilder: (context, index) {
        var collection = widget.collections[index];
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
                  await UtilDialog.showCollectionRemoveDialog(context: context);

              if (dismiss && collection.name != "default") {
                if (collection.name != "default") {
                  BlocProvider.of<HomeBloc>(context)
                      .add(RemoveCollection(collection: collection));
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
            words: widget.words,
            index: index,
          ),
        );
      },
    );
  }
}
