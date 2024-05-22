// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vocab_app/configs/config.dart';
// import 'package:vocab_app/constants/color_constant.dart';
// import 'package:vocab_app/data/models/word_model.dart';
// import 'package:vocab_app/data/repository/api_repository/api_repository.dart';
// import 'package:vocab_app/data/repository/app_repository.dart';
// import 'package:vocab_app/presentation/screens/activity/bloc/bloc.dart';
// import 'package:vocab_app/presentation/widgets/others/loading.dart';
// import 'package:vocab_app/presentation/widgets/single_card/challenge_card.dart';

// class ActivityBody extends StatefulWidget {
//   const ActivityBody({super.key});

//   @override
//   State<ActivityBody> createState() => _ActivityBodyState();
// }

// class _ActivityBodyState extends State<ActivityBody> {
//   late APIRepository _apiRepository;
//   late ActivitiesBloc _activitiesBloc;
//   late List<WordModel> _words = [];

//   @override
//   void initState() {
//     super.initState();
//     _activitiesBloc = BlocProvider.of<ActivitiesBloc>(context);
//     _apiRepository = AppRepository.apiRepository;

//     getWords();
//   }

//   Future getWords() async {
//     var words = await _apiRepository.fetchActivityWords();
//     print(words);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ActivitiesBloc, ActivitiesState>(
//       builder: (context, state) {
//         if (state is ActivityLoading) {
//           return const Expanded(
//             child: Center(
//               child: Loading(),
//             ),
//           );
//         }
//         if (state is ActivityLoaded) {
//           var activity = state.activityResponse.activity;

//           return SizedBox(
//             height: 300,
//             child: Swiper(
//               itemCount: 5,
//               itemWidth: SizeConfig.screenWidth,
//               itemHeight: SizeConfig.screenHeight,
//               layout: SwiperLayout.TINDER,
//               pagination: const SwiperPagination(
//                 builder: DotSwiperPaginationBuilder(
//                   color: COLOR_CONST.activeColor,
//                   activeColor: Colors.white,
//                   activeSize: 12,
//                   space: 4,
//                 ),
//               ),
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {},
//                   child: Stack(
//                     children: [
//                       Column(
//                         children: [
//                           const SizedBox(height: 100),
//                           ChallengeCard(
//                             activity: activity!, //state.[index].word!,
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Hero(
//                           tag: _words[index].word!,
//                           child: Text(_words[index].definition!),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//         return const Center(
//           child: Loading(),
//         );
//       },
//     );
//   }
// }
