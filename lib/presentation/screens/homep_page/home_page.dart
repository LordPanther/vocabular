import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/homep_page/widgets/home_page_form.dart';

class HomePageBloc extends StatelessWidget {
  const HomePageBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Column(
            children: [
              const HomePageHeader(),
              const HomePageForm(),
            ],
          ),
        ),
      ),
    )
  }
}