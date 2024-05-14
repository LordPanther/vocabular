import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/home_repository/firebase_home_repo.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/home_screen/bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;
  final FirebaseHomeRepository _firebaseHomeRepository =
      AppRepository.collectionsRepository;

  HomeBloc() : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
    // on<CreateWord>((event, emit) async {
    //   await _mapCreateWordToMap(event, emit);
    // });
    on<CreateCollection>((event, emit) async {
      await _mapCreateCollectionToMap(event, emit);
    });
    on<RemoveWord>((event, emit) async {
      await _mapRemoveWordToMap(event, emit);
    });
    on<RemoveCollection>((event, emit) async {
      await _mapRemoveCollectionToMap(event, emit);
    });
    on<RefreshHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
  }

  /// Load Home
  Future<void> _mapLoadHomeToMap(event, Emitter<HomeState> emit) async {
    var collectionData = await _homeRepository.fetchCollections();
    List<CollectionModel> collections = collectionData.collections;
    List<WordModel> words = collectionData.words;
    WordModel? recentWord = await _getRecentWord();

    HomeResponse homeResponse = HomeResponse(
        collections: collections, words: words, recentWord: recentWord);
    emit(HomeLoaded(homeResponse: homeResponse));
  }

  Future<WordModel?> _getRecentWord() async {
    List<List<String>> recentWords = await _firebaseHomeRepository.getList();
    if (recentWords.isNotEmpty) {
      List<String> recentWord = recentWords.last;
      var word = WordModel(
        id: recentWord[0],
        definition: recentWord[2],
        word: recentWord[1],
        audioUrl: recentWord[3],
      );
      return word;
    }
    return const WordModel();
  }

  /// Create collection
  Future<void> _mapCreateCollectionToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collection;
    try {
      bool collectionExists = await _homeRepository.addCollection(collection);
      await _mapLoadHomeToMap(event, emit);

      if (collectionExists) {
        emit(CollectionExists(collection));
      } else {
        await _mapLoadHomeToMap(event, emit);
        // emit(CollectionCreated(collection));
      }
    } catch (error) {
      emit(CollectionCreationFailure(error.toString()));
    }
  }

  /// Remove collection
  Future<void> _mapRemoveCollectionToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collection;

    try {
      await _homeRepository.removeCollection(collection);
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      emit(CollectionRemovalFailure(error.toString()));
    }
  }

  /// Remove word
  Future<void> _mapRemoveWordToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collection;
    WordModel word = event.word;
    try {
      await _homeRepository.removeWord(collection, word);
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      HomeLoadFailure(error.toString());
    }
  }
}

class HomeResponse {
  final List<CollectionModel> collections;
  final List<WordModel> words;
  final WordModel? recentWord;

  HomeResponse(
      {required this.collections, required this.words, this.recentWord});
}
