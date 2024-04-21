import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/add_collection/bloc/collection_bloc.dart';
import 'package:vocab_app/presentation/screens/add_collection/bloc/collection_event.dart';
import 'package:vocab_app/presentation/screens/add_collection/widgets/add_collection_body.dart';
import 'package:vocab_app/presentation/screens/add_collection/widgets/add_collection_header.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionBloc()..add(LoadCollectionScreen()),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (context) {
              return const Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AddCollectionHeader(),
                        AddCollectionBody(),
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
