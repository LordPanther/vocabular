import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
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
    on<RefreshHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
  }

  Future<void> _mapLoadHomeToMap(event, Emitter<HomeState> emit) async {
    HomeResponse homeResponse = HomeResponse(
        collections: await _collectionsRepository.fetchCollections());
    emit(HomeLoaded(homeResponse: homeResponse));
  }

  Future<void> _mapCreateCollectionToMap(
      event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collectionModel;
    try {
      await _collectionsRepository.createCollection(collection);
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      emit(HomeLoadFailure(error.toString()));
    }
  }

  Future<void> _mapRemoveCollectionToMap(event, Emitter<HomeState> emit) async {
    CollectionModel collection = event.collection;

    try {
      await _collectionsRepository.removeCollection(collection);
      await _mapLoadHomeToMap(event, emit);
    } catch (error) {
      HomeLoadFailure(error.toString());
    }
  }
}

class HomeResponse {
  final List<CollectionModel> collections;

  HomeResponse({required this.collections});
}
