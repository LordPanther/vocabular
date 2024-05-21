import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home/bloc/home_event.dart';
import 'package:vocab_app/presentation/screens/home/widgets/home_body.dart';
import 'package:vocab_app/presentation/screens/home/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHome()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        IMAGE_CONST.BACKGROUND_ONE,
                      ),
                      fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<HomeBloc>(context).add(RefreshHome());
                    },
                    child: const Column(
                      children: [
                        HomeHeader(),
                        HomeBody(),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.defaultPadding * 7,
                  right: SizeConfig.defaultPadding,
                ),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.defaultSize *
                        .7), // Set the border radius here
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRouter.WORD),
                  backgroundColor: COLOR_CONST.primaryColor,
                  child: const Icon(Icons.add),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
