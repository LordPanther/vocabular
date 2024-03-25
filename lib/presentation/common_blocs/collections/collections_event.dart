import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();

  @override
  List<Object> get props => [];
}

/// Load all collections created by user
class LoadUserCollections extends CollectionsEvent {
  final String collections;

  const LoadUserCollections({
    required this.collections,
  });
}

class AddWord extends CollectionsEvent {
  final WordModel word;

  const AddWord({
    required this.word,
  });

  @override
  List<Object> get props => [word.word];

  @override
  String toString() {
    return 'Loaded{name: ${word.word}';
  }
}

/// Choose to add word or collection in collections screen
class PopulateCollections extends CollectionsEvent {
  final String option;
  final CollectionModel collectionModel;
  final WordModel wordModel;
  const PopulateCollections({
    required this.option,
    required this.collectionModel,
    required this.wordModel,
  });

  @override
  List<Object> get props => [option, wordModel, collectionModel];
}

class RemoveCartItemModel extends CollectionsEvent {
  final CollectionModel collection;

  const RemoveCartItemModel(this.collection);

  @override
  List<Object> get props => [collection];
}

// class AddWordToCollection extends CollectionsEvent {}

/// Collection was updated
class MyCollectionsUpdated extends CollectionsEvent {
  final List<CollectionModel> updatedCollection;

  const MyCollectionsUpdated(this.updatedCollection);

  @override
  List<Object> get props => [updatedCollection];
}
