import 'package:vocab_app/data/models/collections_model.dart';

abstract class CollectionsRepository {

  // Fetch colletions list from firebase
  Stream<List<CollectionsModel>> fetchCollections(String uid);

  Future<void> createCollection(String collection);
}
