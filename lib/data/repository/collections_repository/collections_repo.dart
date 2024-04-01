import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/utils/collection_data.dart';

abstract class CollectionsRepository {
  /// Called once on registration to create collections:[defaultcollections]
  Future<void> createDefaultCollection(UserModel updatedUserDetails);

  /// Create a new collection in UI
  Future<bool> createCollection(CollectionModel collection);

  Future<void> addWordToCollection(CollectionModel collection, WordModel word, bool shareWord);

  /// Fetch list of user created collections
  Future<CollectionData> fetchCollections();

  /// Remove a collection
  Future<void> removeCollection(CollectionModel collection);
}
