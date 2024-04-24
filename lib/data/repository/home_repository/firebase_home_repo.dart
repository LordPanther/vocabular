import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/home_repository/home_repo.dart';
import 'package:vocab_app/utils/collection_data.dart';

class FirebaseHomeRepository implements HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userHome = FirebaseFirestore.instance;

  /// [FirebaseAuthRepository]
  /// Called once on registration to create collections:[defaultcollections]
  @override
  Future<void> createDefaultCollection(UserModel user) async {
    CollectionModel collection = const CollectionModel(
      name: "default",
    );
    WordModel word = WordModel(
        id: collection.name,
        definition:
            "The worlds best app for all those words you use everyday, everywhere.",
        word: "vocabular");
    bool sharedWord = true;

    try {
      // Create default collection
      await addWord(collection, word, sharedWord);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// [CollectionsBloc]
  /// Add collection to collections
  @override
  Future<bool> addCollection(CollectionModel newCollection) async {
    // bool collectionExists = false;

    CollectionData collectionData = await fetchCollections();
    List<CollectionModel> collections = collectionData.collections;

    if (collections.contains(newCollection)) {
      return true;
    } else {
      await addColllectionToUi(newCollection);
    }
    return false;
  }

  @override
  Future<void> addWord(
      CollectionModel collection, WordModel word, bool shareWord) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await _userHome
          .collection("vocabusers")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .set({word.word: word.toMap()}, SetOptions(merge: true));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Future<void> removeWord(CollectionModel collection, WordModel word) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await _userHome
          .collection("vocabusers")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .update({word.word: FieldValue.delete()});
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// Create collection
  Future<void> addColllectionToUi(CollectionModel collection) async {
    User? user = _firebaseAuth.currentUser;

    try {
      await _userHome
          .collection("vocabusers")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .set({});
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// Get a list of collections in collections along with their words
  @override
  Future<CollectionData> fetchCollections() async {
    User? user = _firebaseAuth.currentUser;
    List<CollectionModel> userCollections = [];
    List<List<WordModel>> userWords = [];
    var snapshot = await _userHome
        .collection("vocabusers")
        .doc(user!.uid)
        .collection("collections")
        .get();

    for (var doc in snapshot.docs) {
      CollectionModel collectionModel =
          CollectionModel(name: doc.id); //[0] = default, [1] = work
      userCollections.add(collectionModel);

      List<WordModel> words = await fetchWords(doc);
      userWords.add(words);
    }
    return CollectionData(collections: userCollections, words: userWords);
  }

  /// Fetch words for a specific collection
  Future<List<WordModel>> fetchWords(DocumentSnapshot doc) async {
    User? user = _firebaseAuth.currentUser;
    List<WordModel> words = [];

    try {
      var snapshot = await _userHome
          .collection("vocabusers")
          .doc(user!.uid)
          .collection("collections")
          .doc(doc.id)
          .get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      data.forEach(
        (key, value) {
          words.add(WordModel(
              id: value["id"], definition: value["definition"], word: key));
        },
      );
      return words; // Return the list of words here
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // Return an empty list in case of an error
      return words;
    }
  }

  @override
  Future<void> removeCollection(CollectionModel collection) async {
    User? user = _firebaseAuth.currentUser;

    try {
      await _userHome
          .collection("vocabusers")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .delete();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Future<void> updateHomeData(
      WordModel updatedWord, CollectionModel collection) async {
    await _userHome
        .collection("collections")
        .doc(collection.name)
        .get()
        .then((doc) async {
      if (doc.exists) {
        // update
        await doc.reference.update(updatedWord.toMap());
      }
    }).catchError((error) {});
  }
}
