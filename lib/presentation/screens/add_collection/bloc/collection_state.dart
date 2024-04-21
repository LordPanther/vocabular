import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object?> get props => [];
}

class CollectionAdded extends CollectionState {
  final CollectionModel collection;

  const CollectionAdded(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionAdded: collection:${collection.toString()}}";
  }
}

class CollectionsLoaded extends CollectionState {
  final List<CollectionModel> collections;

  const CollectionsLoaded(this.collections);

  @override
  List<Object> get props => [collections];

  @override
  String toString() {
    return "{CollectionsLoaded: collections:${collections.toString()}}";
  }
}

class Initial extends CollectionState {}

class CollectionAddFailure extends CollectionState {
  final String error;

  const CollectionAddFailure(this.error);
}
