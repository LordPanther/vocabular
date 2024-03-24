import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadCollections extends CollectionsEvent {}

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

class RemoveCartItemModel extends CollectionsEvent {
  final CollectionModel collection;

  const RemoveCartItemModel(this.collection);

  @override
  List<Object> get props => [collection];
}

// class AddWordToCollection extends CollectionsEvent {}

/// Collection was updated
class CollectionsUpdated extends CollectionsEvent {
  final List<CollectionModel> updatedCollection;

  const CollectionsUpdated(this.updatedCollection);

  @override
  List<Object> get props => [updatedCollection];
}
