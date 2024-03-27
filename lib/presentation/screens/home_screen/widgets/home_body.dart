import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;
  int childcount = 0;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
    homeBloc.stream.listen((state) {
      if (state is HomeLoaded) {
        setState(() {
          childcount = state.homeResponse.collections.length;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate childCount every time dependencies change
    homeBloc.stream.listen((state) {
      if (state is HomeLoaded) {
        setState(() {
          childcount = state.homeResponse.collections.length;
        });
      }
    });
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
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              // return UtilDialog.showWaiting(context);
              return const Loading();
            }
            if (state is HomeLoaded) {
              var collections = state.homeResponse.collections;
              childcount = collections.length;
              var collection = collections[index];
              return ListTile(
                title: Text(collection.name),
                subtitle: const Text("Word count..."),
                onTap: () {},
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
        );
      }, childCount: childcount),
    );
  }
}
