import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:vocab_app/presentation/screens/homep_page/widgets/home_page_form.dart';

class HomePageBloc extends StatelessWidget {
  const HomePageBloc({super.key});
=======
import 'package:vocab_app/presentation/screens/homep_page/bloc/home_page_bloc.dart';
import 'package:vocab_app/presentation/screens/homep_page/widgets/home_page_form.dart';
import 'package:vocab_app/presentation/screens/homep_page/widgets/home_page_header.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
<<<<<<< HEAD
        child: Scaffold(
          body: Column(
            children: [
              const HomePageHeader(),
              const HomePageForm(),
=======
        child: const Scaffold(
          body: Column(
            children: [
              HomePageHeader(),
              HomePageForm(),
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)
            ],
          ),
        ),
      ),
<<<<<<< HEAD
    )
=======
    );
>>>>>>> 9d57f11 (Creating logic for adding new word to collection)
  }
}