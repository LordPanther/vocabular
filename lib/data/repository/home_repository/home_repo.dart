import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/utils/collection_data.dart';

abstract class HomeRepository {
  /// Called once on registration to create collections:[defaultcollections]
  Future<void> createDefaultCollection(UserModel updatedUserDetails);

  /// Create a new collection in UI
  Future<bool> addCollection(CollectionModel collection);

  /// Add a new word [word]
  Future<void> addWord(
      CollectionModel collection, WordModel word, bool shareWord);

  /// Remove this word [word]
  Future<void> removeWord(CollectionModel collection, WordModel word);

  /// Fetch list of user created collections
  Future<CollectionData> fetchCollections();

  /// Remove a collection
  Future<void> removeCollection(CollectionModel collection);

  Future<void> updateHomeData(
      WordModel updatedWord, CollectionModel collection);
}
