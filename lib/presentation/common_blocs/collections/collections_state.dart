import 'package:vocab_app/data/models/collections_model.dart';
import 'package:equatable/equatable.dart';

abstract class CollectionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CollectionsLoading extends CollectionsState {}

class CollectionsLoaded extends CollectionsState {
  final CollectionsModel collection;

  CollectionsLoaded(this.collection);

  @override
  List<Object> get props => [collection];

  @override
  String toString() {
    return "{CollectionLoaded: collection:${collection.toString()}}";
  }
}

class CollectionsLoadFailure extends CollectionsState {
  final String error;

  CollectionsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
