import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/snackbar.dart';

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

  /// Remove/Delete collection and its content
  onRemoveCollection(CollectionModel collection) {
    homeBloc.add(RemoveCollection(collection));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is CollectionExists) {
          UtilSnackBar.showSnackBarContent(context,
              content: "Collection already exists");
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Loading();
          }
          if (state is HomeLoaded) {
            var collections = state.homeResponse.collections;
            return Expanded(
              child: ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  var collection = collections[index];
                  return ListTile(
                    title: Text(collection.name),
                    subtitle: const Text("Word count..."),
                    onTap: () {},
                    trailing: collection.name == "default"
                        ? null
                        : IconButton(
                            onPressed: () => onRemoveCollection(collection),
                            icon: const Icon(CupertinoIcons.minus),
                          ),
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
}
