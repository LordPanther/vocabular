import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/collections/bloc/bloc.dart';
import 'package:vocab_app/presentation/screens/collections/widget/collections_form.dart';
import 'package:vocab_app/presentation/screens/collections/widget/collections_header.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: Column(
            children: [
              CollectionsHeader(),
              CollectionsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
