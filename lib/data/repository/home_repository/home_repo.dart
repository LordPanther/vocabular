import 'package:vocab_app/data/models/addword_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/utils/collection_data.dart';

abstract class HomeRepository {
  /// Called once on registration to create collections:[defaultcollections]
  Future<void> createDefaultCollection();

  /// Create a new collection in UI
  Future<bool> addCollection(CollectionModel collection);

  Future<List<List<String>>> getList();

  /// Add a new word [word]
  Future<void> addWord(WordModel word);

  /// Remove this word [word]
  Future<void> removeWord(CollectionModel collection, WordModel word);

  /// Fetch list of user created collections
  Future<CollectionData> fetchCollections();

  /// Remove a collection
  Future<void> removeCollection(CollectionModel collection);

  Future<void> updateHomeData(AddWordModel updatedWord, WordModel oldWord);

  Future<void> migrateGuestCollections(CollectionData data);
}
