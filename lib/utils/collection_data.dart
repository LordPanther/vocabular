import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

class CollectionData {
  List<CollectionModel> collections;
  List<List<WordModel>> words;

  CollectionData({required this.collections, required this.words});
}
