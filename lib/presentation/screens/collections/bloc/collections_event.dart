import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';

abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();

  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionsEvent {}

/// Choose to add collection in collections screen
class CreateCollection extends CollectionsEvent {
  final CollectionModel collection;
  const CreateCollection({
    required this.collection,
  });

  @override
  List<Object> get props => [collection];
}

class RemoveCollection extends CollectionsEvent {
  final CollectionModel collection;

  const RemoveCollection(this.collection);

  @override
  List<Object> get props => [collection];
}
