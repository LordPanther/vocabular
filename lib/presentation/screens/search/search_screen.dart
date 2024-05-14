// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_bloc.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_event.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_state.dart';
import 'package:vocab_app/presentation/screens/search/widgets/search_bar.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchControler = TextEditingController();
  final AuthRepository _authRepository = AppRepository.authRepository;

  @override
  void dispose() {
    searchControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(OpenScreen()),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchingBar(searchController: searchControler),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildContent() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is Searching) {
          return const Loading();
        }
        if (state is SuggestionLoaded) {
          return _buildSuggestion(state);
        }
        if (state is ResultsLoaded) {
          return _buildResults(state);
        }
        if (state is SearchFailure) {
          return Center(
              child: Text(Translate.of(context).translate("load_failure")));
        }
        return Center(
            child: Text(Translate.of(context).translate("fall_back_error")));
      },
    );
  }

  _buildSuggestion(SuggestionLoaded state) {
    Widget recentSearchWidget = Container();
    Widget hotKeywordsWidget = Container();
    if (state.recentKeywords.isNotEmpty) {
      recentSearchWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translate.of(context).translate("recent_search"),
            style: FONT_CONST.BOLD_DEFAULT_20,
          ),
          Wrap(
            children: List.generate(
              state.recentKeywords.length,
              (index) {
                return _buildSuggestionItem(state.recentKeywords[index]);
              },
            ),
          ),
        ],
      );
    }
    // ignore: prefer_is_empty
    if (state.hotKeywords.length > 0) {
      hotKeywordsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translate.of(context).translate("hot_keywords"),
            style: FONT_CONST.BOLD_DEFAULT_20,
          ),
          Wrap(
            children: List.generate(state.hotKeywords.length, (index) {
              return _buildSuggestionItem(state.hotKeywords[index]);
            }),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentSearchWidget,
          SizedBox(height: SizeConfig.defaultSize * 3),
          hotKeywordsWidget,
          SizedBox(height: SizeConfig.defaultSize * 10),
          CustomTextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            buttonName: Translate.of(context).translate('back'),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          )
        ],
      ),
    );
  }

  _buildResults(ResultsLoaded state) {
    List<WordModel> words = state.wordResults;

    if (words.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultPadding),
        physics: const BouncingScrollPhysics(),
        itemCount: words.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(words[index].word!),
            onTap: () {
              // Implement onTap action if needed
              // UtilDialog.showSeadrchDetail(context, index: index, words: words);
              UtilDialog.showWordDetails(context,
                  tooltip: "Add audio recording",
                  word: words[index],
                  user: _authRepository);
            },
          );
        },
      );
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Translate.of(context).translate("no_word"),
            style: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
          SizedBox(height: SizeConfig.defaultSize * 10),
          CustomTextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(AppRouter.WORD);
            },
            buttonName: Translate.of(context).translate('add_word'),
            buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
          ),
        ],
      ));
    }
  }

  _buildSuggestionItem(String keyword) {
    return GestureDetector(
      onTap: () {
        searchControler.text = keyword;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.defaultSize * 3,
          vertical: SizeConfig.defaultSize * 1.5,
        ),
        margin: EdgeInsets.only(
          top: SizeConfig.defaultSize,
          right: SizeConfig.defaultSize,
        ),
        decoration: BoxDecoration(
          color: COLOR_CONST.primaryColor.withOpacity(0.3).withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          keyword,
          style: FONT_CONST.BOLD_DEFAULT_16,
        ),
      ),
    );
  }
}
