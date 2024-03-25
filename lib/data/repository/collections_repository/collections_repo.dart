import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/models/user_model.dart';

abstract class CollectionsRepository {

  /// Called once on registration to create collections:[defaultcollections]
  Future<void> addCollectinData(UserModel updatedUserDetails);

  /// Fetch collections list from firebase "collections": []
  Stream<List<CollectionModel>> fetchCollections(String uid, String collection);

  Future<List<CollectionModel>> fetchUserCollections();

  Future<void> addColllectionToList(CollectionModel collectionModel);

  Future<void> createCollection(List<CollectionModel> collection);

  Future<void> updateCollections(String collection, WordModel wordData);
}
