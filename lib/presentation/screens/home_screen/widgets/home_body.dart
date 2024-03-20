import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/router.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_bloc.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';
import 'package:vocab_app/presentation/widgets/others/daily_word_widget.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';
import 'package:vocab_app/utils/translate.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          if (homeState is HomeLoaded) {
            var homeResponse = homeState.homeResponse;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildDailyWordHeading(
                    context,
                  ),
                  _buildDailyWord(
                    context,
                    homeResponse.dailyWord,
                  ),
                  _buildCollectionsHeading(
                    context,
                  ),
                  _buildHomeCollections(
                    context,
                    homeResponse.collections,
                  ),
                ],
              ),
            );
          }
          if (homeState is HomeLoading) {
            return const Loading();
          }
          if (homeState is HomeLoadFailure) {
            return Center(child: Text(homeState.error));
          }
          return const Center(child: Text("Something went wrong."));
        },
      ),
    );
  }

  _buildDailyWordHeading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
        ),
        alignment: Alignment.centerLeft,
        height: SizeConfig.defaultSize * 10,
        child: Text(
          Translate.of(context).translate('daily_word'),
          style: FONT_CONST.MEDIUM_DEFAULT_18,
        ));
  }

  _buildDailyWord(BuildContext context, WordModel dailyWord) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: COLOR_CONST.cardShadowColor.withOpacity(0.2),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DailyWordWidget(wordMap: dailyWord),
    );
  }

  _buildCollectionsHeading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
        ),
        alignment: Alignment.centerLeft,
        height: SizeConfig.defaultSize * 10,
        child: Text(
          Translate.of(context).translate('collections'),
          style: FONT_CONST.MEDIUM_DEFAULT_18,
        ));
  }

  _buildHomeCollections(
      BuildContext context, List<CollectionsModel> collections) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      child: ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return CollectionsModelCard(
            collection: collections[index],
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.COLLECTIONS,
                arguments: collections[index],
              );
            },
          );
        },
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
