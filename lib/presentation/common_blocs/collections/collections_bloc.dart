import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_event.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_state.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;
  late User _loggedFirebaseUser;
  StreamSubscription? _fetchCollectionsSub;

  CollectionsBloc() : super(CollectionsLoading()) {
    on<LoadCollections>((event, emit) async {
      await _mapLoadCollectionsToState(event, emit);
    });
    on<CollectionsUpdated>((event, emit) async {
      await _mapCollectionsUpdatedToState(event, emit);
    });
  }

  Future<void> _mapLoadCollectionsToState(
      event, Emitter<CollectionsState> emit) async {
    try {
      _fetchCollectionsSub?.cancel();
      _loggedFirebaseUser = _authRepository.loggedFirebaseUser;
      _fetchCollectionsSub = _collectionsRepository
          .fetchCollections(_loggedFirebaseUser.uid)
          .listen((collections) => add(CollectionsUpdated(collections)));
    } catch (e) {
      emit(CollectionsLoadFailure(e.toString()));
    }
  }

  Future<void> _mapCollectionsUpdatedToState(
      event, Emitter<CollectionsState> emit) async {
    emit(CollectionsLoading());

    var collections = event.collections;

    emit(CollectionsLoaded(collections: collections));
  }
}
