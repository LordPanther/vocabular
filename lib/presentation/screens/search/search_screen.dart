// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_bloc.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_event.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_state.dart';
import 'package:vocab_app/presentation/screens/search/widgets/search_bar.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchControler = TextEditingController();

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SearchingBar(searchController: searchControler),
              Expanded(child: _buildContent()),
            ],
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
              child: Text(Translate.of(context).translate('error_three')));
        }
        return Center(
            child: Text(Translate.of(context).translate('error_one')));
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
            style: FONT_CONST.BOLD_DEFAULT_26,
          ),
          Wrap(
            children: List.generate(state.recentKeywords.length, (index) {
              return _buildSuggestionItem(state.recentKeywords[index]);
            }),
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
            style: FONT_CONST.BOLD_DEFAULT_26,
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
          hotKeywordsWidget
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
              UtilDialog.showSeadrchDetail(context, index: index, words: words);
            },
          );
        },
      );
    } else {
      return Center(
        child: Image.asset(
          IMAGE_CONST.NOT_FOUND,
          width: SizeConfig.defaultSize * 25,
          height: SizeConfig.defaultSize * 25,
        ),
      );
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
          color: COLOR_CONST.primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          keyword,
          style: FONT_CONST.BOLD_DEFAULT_16,
        ),
      ),
    );
  }
}
