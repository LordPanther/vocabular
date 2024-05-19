// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/common_blocs/settings/bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/home_data.dart';
import 'package:vocab_app/presentation/widgets/single_card/recentWord_card.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:vocab_app/utils/utils.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeBloc homeBloc;
  bool _showRecentWord = false;
  final AuthRepository _authRepository = AppRepository.authRepository;

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    showRecentWord();
  }

  void showRecentWord() {
    _showRecentWord = LocalPref.getBool("showRecentWord") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, settingState) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(),
                    ],
                  ),
                ),
              );
            }
            if (state is HomeLoaded) {
              _showRecentWord = LocalPref.getBool("showRecentWord") ?? false;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.defaultPadding),
                  child: Column(
                    children: [
                      _authRepository.isAnonymous
                          ? const SizedBox.shrink()
                          : _showRecentWord
                              ? RecentWordTile(
                                  recentWord: HomeData.getRecentWord(state))
                              : const SizedBox.shrink(),
                      Expanded(
                        child: ReOrderableTile(
                          words: HomeData.getWords(state),
                          collections: HomeData.getCollections(state),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Expanded(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Translate.of(context).translate("load_failure"),
                  ),
                ],
              )),
            );
          },
        );
      },
    );
  }
}
