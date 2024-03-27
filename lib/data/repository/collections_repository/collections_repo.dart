import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/user_model.dart';

abstract class CollectionsRepository {
  /// Called once on registration to create collections:[defaultcollections]
  Future<void> addCollectionData(UserModel updatedUserDetails);

  /// Fetch list of user created collections:[]
  Future<List<CollectionModel>> fetchUserCollections();

  Future<void> addColllectionToList(CollectionModel collectionModel);

  Future<void> createCollection(List<CollectionModel> collection);

}
