import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/home_repository/home_repo.dart';
import 'package:vocab_app/presentation/screens/collection/bloc/collection_event.dart';
import 'package:vocab_app/presentation/screens/collection/bloc/collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;
  List<CollectionModel> collections = [];

  CollectionBloc() : super(Initial()) {
    on<AddCollection>((event, emit) async {
      await _mapAddCollectionToMap(event, emit);
    });
    on<LoadCollectionScreen>((event, emit) async {
      await _mapGetCollectionsToMap(event, emit);
    });
  }

  Future<void> _mapAddCollectionToMap(
      event, Emitter<CollectionState> emit) async {
    CollectionModel collection = event.collection;
    try {
      await _homeRepository.addCollection(collection);
      emit(CollectionAdded(collection));
    } catch (error) {
      emit(CollectionAddFailure(error.toString()));
    }
  }

  Future<void> _mapGetCollectionsToMap(
      event, Emitter<CollectionState> emit) async {
    try {
      var collectionData = await _homeRepository.fetchCollections();
      collections = collectionData.collections;
      emit(CollectionsLoaded(collections));
    } catch (error) {
      emit(CollectionAddFailure(error.toString()));
    }
  }
}
