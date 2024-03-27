import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/collections_event.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/collections_state.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  // final AuthRepository _authRepository = AppRepository.authRepository;
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;
  // late User _loggedFirebaseUser;
  StreamSubscription? _fetchCollectionsSub;

  CollectionsBloc() : super(CollectionsLoading()) {
    on<CreateCollection>((event, emit) async {
      await _mapCreateCollectionToMap(event, emit);
    });
    on<RemoveCollection>((event, emit) async {
      await _mapRemoveCollection(event, emit);
    });
  }

  
  Future<void> _mapCreateCollectionToMap(
      event, Emitter<CollectionsState> emit) async {
    CollectionModel collection = event.collectionModel;
    try {
      await _collectionsRepository.createCollection(collection);
      emit(CollectionCreated(collection));
    } catch (error) {
      emit(CollectionCreationFailure(error.toString()));
    }
  }

  /// Populate words in firestore collection
  Future<void> _mapRemoveCollection(
      event, Emitter<CollectionsState> emit) async {
    CollectionModel collection = event.collection;

    try {
      await _collectionsRepository.removeCollection(collection);
      emit(CollectionRemoved());
    } catch (error) {
      CollectionRemovalFailure(error.toString());
    }
  }
}
