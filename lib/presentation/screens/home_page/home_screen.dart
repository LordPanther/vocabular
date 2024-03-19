import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/home_page/home/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_page/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_page/widgets/home_body.dart';
import 'package:vocab_app/presentation/screens/home_page/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHome()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(RefreshHome());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: HomePersistentHeader(),
                      pinned: true,
                    ),
                    const HomeBody(),
                  ],
                ),
              ),
            ),
          );
        },)
      ),
    );
  }
}
