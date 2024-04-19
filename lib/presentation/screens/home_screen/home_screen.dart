import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/home_body.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CollectionModel> collections = [];

  // Callback function to receive collections from HomeBody
  void receiveCollections(List<CollectionModel> receivedCollections) {
    setState(() {
      collections = receivedCollections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHome()),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<HomeBloc>(context).add(RefreshHome());
                    },
                    child: Column(
                      children: [
                        HomeHeader(collections: collections),
                        HomeBody(sendCollections: receiveCollections),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
