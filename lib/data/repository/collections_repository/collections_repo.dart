import 'package:vocab_app/data/models/collections_model.dart';

abstract class CollectionsRepository {
  Future<List<CollectionsModel>> fetchWordCollections();
}