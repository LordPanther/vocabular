import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';

class Initializer {
  final AuthRepository _authRepository = AppRepository.authRepository;

  User? get user => _authRepository.currentUser;

  Future<AddWordModel> instantiateModels(
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

  Future<WordModel> instantiateWordModel(
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

  Future<CollectionModel> instantiateCollModel(String? collection) async {
    var collectionModel = CollectionModel(name: collection);
    return collectionModel;
  }

  ///Singleton factory
  static final Initializer _instance = Initializer._internal();

  factory Initializer() {
    return _instance;
  }
  Initializer._internal();
}
