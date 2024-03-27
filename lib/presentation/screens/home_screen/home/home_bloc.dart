import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_event.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;
  HomeBloc() : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
    on<RefreshHome>((event, emit) async {
      await _mapLoadHomeToMap(event, emit);
    });
  }

  Future<void> _mapLoadHomeToMap(event, Emitter<HomeState> emit) async {
    HomeResponse homeResponse = HomeResponse(
        collections: await _collectionsRepository.fetchUserCollections());
    emit(HomeLoaded(homeResponse: homeResponse));
  }

  Future<void> _mapRefreshHomeToMap(event, Emitter<HomeState> emit) async {}
}

class HomeResponse {
  final List<CollectionModel> collections;

  HomeResponse({required this.collections});
}
