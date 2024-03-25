import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/app_view.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/data/repository/collections_repository/firebase_collections_repo.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_event.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_state.dart';
import 'package:vocab_app/utils/dialog.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;
  final WordRepository _wordRepository =
      AppRepository.wordRepository;
  late User _loggedFirebaseUser;
  StreamSubscription? _fetchCollectionsSub;

  CollectionsBloc() : super(CollectionsLoading()) {
    on<PopulateCollections>((event, emit) async {
      await _mapPopulateCollectionsToMap(event, emit);
    });
    on<LoadUserCollections>((event, emit) async {
      await _mapMyCollectionsToState(event, emit);
    });
    on<MyCollectionsUpdated>((event, emit) async {
      await _mapCollectionsUpdatedToState(event, emit);
    });
  }

  ///[UtilDialog]
  ///
  Future<void> _mapPopulateCollectionsToMap(event, Emitter<CollectionsState> emit) async {
    String option = event.option;
    CollectionModel collectionModel = event.collectionModel;
    WordModel wordModel = event.wordModel;

    switch (option) {
      case "collection":
        await _collectionsRepository.addColllectionToList(collectionModel);
        break;
      case "word":
        await _wordRepository.addWordToCollection(wordModel, collectionModel);
        break;
      default:
        if (kDebugMode) {
          print("Unknown OPTION error");
        }

    }

    if (option == "collection") {
      /// [Fire]

    } else {
      /// Add word

    }
  }

  /// [AppView]
  /// Called on App startup to load collections to UI
  Future<void> _mapMyCollectionsToState(
      event, Emitter<CollectionsState> emit) async {
    
    String collection = event.collection;
    try {
      _fetchCollectionsSub?.cancel();
      _loggedFirebaseUser = _authRepository.loggedFirebaseUser;
      _fetchCollectionsSub = _collectionsRepository
          .fetchCollections(_loggedFirebaseUser.uid, collection)
          .listen((userCollections) => add(MyCollectionsUpdated(userCollections)));
    } catch (e) {
      emit(CollectionsLoadFailure(e.toString()));
    }
  }

  /// [FirebaseCollectionsRepository]
  /// Stream will trigger collection on change in collections:[collections]
  Future<void> _mapCollectionsUpdatedToState(
      event, Emitter<CollectionsState> emit) async {
    emit(CollectionsLoading());

    var collections = event.userCollections;
    try {
      await _collectionsRepository.createCollection(collections);
      emit(CollectionsLoaded(collections: collections));
    } catch (error) {
      emit(CollectionsLoadFailure(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _fetchCollectionsSub?.cancel();
    return super.close();
  }

  void _mapAddCollectionToMap(event, Emitter<dynamic> emit) {}

  void _mapAddWordToMap(event, Emitter<dynamic> emit) {}
}