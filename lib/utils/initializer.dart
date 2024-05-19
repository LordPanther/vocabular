import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

class WordsManager {
  static Future<AddWordModel> instantiateModels(
    String? collection,
    String word,
    String definition,
    String audioUrl,
    String? timeStamp,
    bool isShared,
  ) async {
    var wordModel = await instantiateWordModel(
      collection!,
      word,
      definition,
      audioUrl,
      timeStamp,
      isShared,
    );

    var collModel = await instantiateCollModel(collection);
    var addWordModel = AddWordModel(word: wordModel, collection: collModel);
    return addWordModel;
  }

  static Future<WordModel> instantiateWordModel(
    String collection,
    String word,
    String definition,
    String audioUrl,
    String? timeStamp,
    bool isShared,
  ) async {
    var wordModel = WordModel(
      id: collection,
      word: word,
      definition: definition,
      audioUrl: audioUrl,
      timeStamp: timeStamp!,
      isShared: isShared,
    );
    return wordModel;
  }

  static Future<CollectionModel> instantiateCollModel(
      String? collection) async {
    var collectionModel = CollectionModel(name: collection);
    return collectionModel;
  }

  ///Singleton factory
  static final WordsManager _instance = WordsManager._internal();

  factory WordsManager() {
    return _instance;
  }
  WordsManager._internal();
}
