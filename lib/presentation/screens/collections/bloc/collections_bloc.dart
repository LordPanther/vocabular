import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/screens/collections/bloc/collections_event.dart';
import 'package:vocab_app/presentation/screens/collections/bloc/collections_state.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;

  CollectionsBloc() : super(CollectionsLoading()) {
    on<CreateCollection>((event, emit) async {
      await _mapCreateCollectionToMap(event, emit);
    });
    on<RemoveCollection>((event, emit) async {
      await _mapRemoveCollectionToMap(event, emit);
    });
  }

  /// Create collection
  Future<void> _mapCreateCollectionToMap(
      event, Emitter<CollectionsState> emit) async {
    CollectionModel collection = event.collectionModel;
    try {
      bool collectionExists =
          await _collectionsRepository.createCollection(collection);
      if (collectionExists) {
        emit(CollectionExists(collection));
      } else {
        emit(CollectionCreated(collection));
      }
    } catch (error) {
      emit(CollectionLoadFailure(error.toString()));
    }
  }

  /// Remove collection
  Future<void> _mapRemoveCollectionToMap(
      event, Emitter<CollectionsState> emit) async {
    CollectionModel collection = event.collection;

    try {
      await _collectionsRepository.removeCollection(collection);
    } catch (error) {
      emit(CollectionLoadFailure(error.toString()));
    }
  }
}
