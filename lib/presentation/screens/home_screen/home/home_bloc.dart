import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;

  HomeBloc() : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
    on<CreateCollection>((event, emit) async {
      await _mapCreateCollectionToMap(event, emit);
    });
    on<RemoveCollection>((event, emit) async {
      await _mapRemoveCollectionToMap(event, emit);
    });
    on<CreateWord>((event, emit) async {
      await _mapCreateWordToMap(event, emit);
    });
    on<RemoveWord>((event, emit) async {
      await _mapRemoveWordToMap(event, emit);
    });
    on<RefreshHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
  }

  /// Load Home
  Future<void> _mapLoadHomeToMap(event, Emitter<HomeState> emit) async {
    var collectionData = await _collectionsRepository.fetchCollections();
    List<CollectionModel> collections = collectionData.collections;
    List<List<WordModel>> words = collectionData.words;

    HomeResponse homeResponse = HomeResponse(
      collections: collections,
      words: words,
    );
    emit(HomeLoaded(homeResponse: homeResponse));
  }

  /// Create collection
  Future<void> _mapCreateCollectionToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collectionModel;
    try {
      bool collectionExists =
          await _collectionsRepository.createCollection(collection);
      if (collectionExists) {
        emit(CollectionExists());
      }
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      emit(HomeLoadFailure(error.toString()));
    }
  }

  /// Create word
  Future<void> _mapCreateWordToMap(event, Emitter<HomeState> emit) async {
    WordModel word = event.word;
    CollectionModel collection = event.collection;
    bool shareWord = event.shareWord;
    try {
      await _collectionsRepository.addWordToCollection(
          collection, word, shareWord);
    } catch (error) {
      emit(HomeLoadFailure(error.toString()));
    }
  }

  /// Remove collection
  Future<void> _mapRemoveCollectionToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collection;

    try {
      await _collectionsRepository.removeCollection(collection);
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      HomeLoadFailure(error.toString());
    }
  }

  /// Remove word
  Future<void> _mapRemoveWordToMap(event, Emitter<HomeState> emit) async {

    try {} catch (error) {
      HomeLoadFailure(error.toString());
    }
  }
}

class HomeResponse {
  final List<CollectionModel> collections;
  final List<List<WordModel>> words;

  HomeResponse({required this.collections, required this.words});
}
