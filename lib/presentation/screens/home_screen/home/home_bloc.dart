import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/data/repository/word_repository/word_repo.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;
  final WordRepository _wordRepository = AppRepository.wordRepository;
  // UserModel? _loggedUser;

  HomeBloc() : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      await _mapLoadHomeToState(event, emit);
    });
    on<RefreshHome>((event, emit) async {
      await _mapLoadHomeToState(event, emit);
    });
  }

  Future<void> _mapLoadHomeToState(event, Emitter<HomeState> emit) async {
    try {
      HomeResponse homeResponse = HomeResponse(
        dailyWord: await _wordRepository.fetchDailyWord(),
        collections: await _collectionsRepository.fetchWordCollections(),
      );
      emit(HomeLoaded(homeResponse: homeResponse));
    } catch (e) {
      emit(HomeLoadFailure(e.toString()));
    }
  }
}

class HomeResponse {
  // Random common words
  final WordModel dailyWord;
  final List<CollectionsModel> collections;

  HomeResponse({
    required this.dailyWord,
    required this.collections,
  });
}
