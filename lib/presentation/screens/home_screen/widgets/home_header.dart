import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/dialogs/form_dialog.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/dialogs/popup_dialog.dart';

class HomeHeader extends StatelessWidget {
  final List<CollectionModel> collections;
  const HomeHeader({super.key, required this.collections});

  void _onOptionDialog(BuildContext context, List<CollectionModel> collections) async {
    final String results = await showDialog(
      context: context,
      builder: (context) {
        return SelectionDialog(collections: collections);
      },
    );
    CollectionModel collection = CollectionModel(name: results[1]);
    // ignore: use_build_context_synchronously
    _onFormDialog(context, results[0], collection);
  }

  _onFormDialog(BuildContext context, String option, CollectionModel collection) async {
    Map<String, dynamic> results = await showDialog(
      context: context,
      builder: (context) {
        return FormDialog(option: option);
      },
    );
    WordModel word = results["wordModel"];
    bool isChecked = results["isChecked"];
    if (context.mounted) {
      if (option == "collection") {
        BlocProvider.of<HomeBloc>(context)
            .add(CreateCollection(collectionModel: collection));
      } else {
        BlocProvider.of<HomeBloc>(context)
            .add(CreateWord(collection: collection, word: word, shareWord: isChecked));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.6),
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Colors.white, // Adjust as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {
              // Navigator.of(context).pushNamed(AppRouter.SEARCH);
            },
          ),
          Text(
            "Vocabula®",
            style: FONT_CONST.BOLD_PRIMARY_18,
          ),
          IconButton(
              icon: const Icon(CupertinoIcons.add),
              onPressed: () => _onOptionDialog(context, collections)),
        ],
      ),
    );
  }
}
