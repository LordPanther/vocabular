import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/models/word_api_model.dart';
import 'package:vocab_app/data/repository/word_repository/word_repo.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';

class FirebaseWordRepository implements WordRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _dailyWordModel = FirebaseFirestore.instance.collection("dailyword");
  final _words = FirebaseFirestore.instance.collection("words");
  var wordsCollection = FirebaseFirestore.instance;

  String _firestoreException = "Firestore exception";

  @override

  String get firestoreException => _firestoreException;

  @override
  Future<WordModel> fetchDailyWord() async {
    User? user = _firebaseAuth.currentUser;

    return await _dailyWordModel
        .doc(user!.uid)
        .get()
        .then((doc) => WordModel.fromMap(doc.data() as Map<String, dynamic>))
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    }, test: (error) {
      return error is int && error >= 400;
    });
  }

  @override
  Future<void> addNewWord(WordModel word) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      await _dailyWordModel.doc(user.uid).set(word.toMap()).catchError((error) {
        _firestoreException = error.toString();
      });
    }
  }

  // Add word to collection
  @override
  Future<void> addWordToCollection(WordModel word, CollectionsModel collection) async {
    User? user = _firebaseAuth.currentUser;
    await wordsCollection
        .collection("collections/${user!.uid}/$collection").doc().set(word.toMap());
  }

  //Map new daily word from api to firestore database
  @override
  Future<void> getWordFromApi(WordApiModel word) async {
    // ignore: body_might_complete_normally_catch_error
    await _words.add(word.toMap()).catchError((error) {
      _firestoreException = error.toString();
    });
  }
}
