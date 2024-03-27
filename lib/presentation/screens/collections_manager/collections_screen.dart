import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/collections_bloc.dart';
import 'package:vocab_app/presentation/screens/collections_manager/widgets/collections_body.dart';
import 'package:vocab_app/presentation/screens/collections_manager/widgets/collections_header.dart';

class CollectionScreen extends StatelessWidget {
  final String option;
  const CollectionScreen({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const CollectionsHeader(),
                ListCollectionsModel(option: option),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
