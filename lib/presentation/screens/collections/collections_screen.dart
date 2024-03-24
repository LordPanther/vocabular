import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_bloc.dart';
import 'package:vocab_app/presentation/screens/collections/widgets/collections_body.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListCollectionsModel(),
          ),
        ),
      ),
    );
  }
}
