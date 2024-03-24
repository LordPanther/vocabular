import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

abstract class CollectionsRepository {
  // Fetch colletions list from firebase
  Stream<List<CollectionModel>> fetchCollections(String uid);

  // Fetch single colletion from firebase
  Stream<List<CollectionModel>> fetchCollection(String uid);

  Future<void> createCollection(String collection);

  Future<void> updateCollections(String collection, WordModel wordData);
}
