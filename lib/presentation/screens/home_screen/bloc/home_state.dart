import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';

import 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// HOME

class HomeLoaded extends HomeState {
  final HomeResponse homeResponse;

  const HomeLoaded({required this.homeResponse});

  @override
  List<Object?> get props => [homeResponse];
}

class HomeLoading extends HomeState {}

class HomeLoadFailure extends HomeState {
  final String error;

  const HomeLoadFailure(this.error);
}

/// COLLECTIONS

class CollectionCreated extends HomeState {
  final CollectionModel collection;

  const CollectionCreated(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionCreated: collection:${collection.toString()}}";
  }
}

class CollectionExists extends HomeState {
  final CollectionModel collection;
  const CollectionExists(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionExists: collection:${collection.toString()}}";
  }
}

class CollectionsLoaded extends HomeState {
  final List<CollectionModel> collections;

  const CollectionsLoaded({required this.collections});

  @override
  List<Object> get props => [collections];

  @override
  String toString() {
    return "{CollectionLoaded: collection:${collections.toString()}}";
  }
}

class CollectionLoadFailure extends HomeState {
  final String error;

  const CollectionLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CollectionCreationFailure extends HomeState {
  final String error;

  const CollectionCreationFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return "{CollectionCreationFailure: error:${error.toString()}}";
  }
}

class CollectionRemoved extends HomeState {}

class CollectionRemovalFailure extends HomeState {
  final String error;

  const CollectionRemovalFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return "{CollectionCreationFailure: error:${error.toString()}}";
  }
}

/// WORDS
