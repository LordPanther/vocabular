import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';

class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object> get props => [];
}

class AddCollection extends CollectionEvent {
  final CollectionModel collection;
  const AddCollection(
      {required this.collection});

  @override
  List<Object> get props => [collection];
}

class LoadCollectionScreen extends CollectionEvent {}