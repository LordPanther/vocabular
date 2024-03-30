import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AddToCollection extends HomeEvent {
  final String collection;

  const AddToCollection({required this.collection});
}

/// Choose to add collection in collections screen
class CreateCollection extends HomeEvent {
  final CollectionModel collectionModel;
  const CreateCollection({
    required this.collectionModel,
  });

  @override
  List<Object> get props => [collectionModel];
}

class RemoveCollection extends HomeEvent {
  final CollectionModel collection;

  const RemoveCollection(this.collection);

  @override
  List<Object> get props => [collection];
}

class LoadCollections extends HomeEvent {}

class LoadHome extends HomeEvent {}

class RefreshHome extends HomeEvent {}
