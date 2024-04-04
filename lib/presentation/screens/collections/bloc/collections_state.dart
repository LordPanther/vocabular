import 'package:vocab_app/data/models/collections_model.dart';
import 'package:equatable/equatable.dart';

abstract class CollectionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CollectionsLoading extends CollectionsState {}

class CollectionsLoaded extends CollectionsState {
  final List<CollectionModel> collections;

  CollectionsLoaded({required this.collections});

  @override
  List<Object> get props => [collections];

  @override
  String toString() {
    return "{CollectionLoaded: collection:${collections.toString()}}";
  }
}

class CollectionLoadFailure extends CollectionsState {
  final String error;

  CollectionLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CollectionCreated extends CollectionsState {
  final CollectionModel collection;

  CollectionCreated(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionCreated: collection:${collection.toString()}}";
  }
}

class CollectionExists extends CollectionsState {
  final CollectionModel collection;
  CollectionExists(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionExists: collection:${collection.toString()}}";
  }
}

class CollectionCreationFailure extends CollectionsState {
  final String error;

  CollectionCreationFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return "{CollectionCreationFailure: error:${error.toString()}}";
  }
}

class CollectionRemoved extends CollectionsState {}

class CollectionRemovalFailure extends CollectionsState {
  final String error;

  CollectionRemovalFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return "{CollectionCreationFailure: error:${error.toString()}}";
  }
}
