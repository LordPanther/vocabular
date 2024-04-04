import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/utils/collection_data.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance;

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
      // Create collections array
      await writeToCollectionsArray(collection);

      // Create default collection
      await addWordToCollection(collection, word, sharedWord);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// [CollectionsBloc]
  /// Add collection to collections
  @override
  Future<bool> createCollection(CollectionModel newCollection) async {
    // bool collectionExists = false;

    CollectionData collectionData = await fetchCollections();
    List<CollectionModel> collections = collectionData.collections;

    if (collections.contains(newCollection)) {
      return true;
    } else {
      await writeToCollectionsArray(newCollection);
      await addColllectionToUi(newCollection);
    }
    return false;
  }

  /// If collection does not exist then create it
  Future<void> writeToCollectionsArray(CollectionModel collection) async {
    User? user = _firebaseAuth.currentUser;
    await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collectionsbucket")
        .doc("bucket")
        .set(
      {
        "collections": [collection.toMap()]
      },
    );
  }

  @override
  Future<void> addWordToCollection(
      CollectionModel collection, WordModel word, bool shareWord) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await _userCollection
          .collection("users")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .set({word.word: word.toMap()});
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
      await _userCollection
          .collection("users")
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
    var snapshot = await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collections")
        .get();

    for (var doc in snapshot.docs) {
      CollectionModel collectionModel =
          CollectionModel(name: doc.id); //[0] = default, [1] = work
      userCollections.add(collectionModel);

      List<WordModel> words = await fetchWords(doc);
      userWords.add(words);

      // var data = doc.data();
      // var collectionsData = data[collectionModel.name];

      // List<WordModel> wordsByCollection = [];
      // for (var wordData in collectionsData) {
      //   var word = WordModel.fromMap(wordData as Map<String, dynamic>);
      //   wordsByCollection.add(word);
      // }
      // userWords.add(wordsByCollection);
    }
    return CollectionData(collections: userCollections, words: userWords);
  }

  /// Get a list of collections in collections
  // @override
  // Future<List<CollectionModel>> fetchCollections() async {
  //   User? user = _firebaseAuth.currentUser;
  //   List<CollectionModel> userCollections = [];
  //   List<WordModel> userWords = [];
  //   var snapshot = await _userCollection
  //       .collection("users")
  //       .doc(user!.uid)
  //       .collection("collections")
  //       .get();

  //   for (var doc in snapshot.docs) {
  //     CollectionModel collectionModel = CollectionModel(name: doc.id);
  //     userCollections.add(collectionModel);
  //     var words = await fetchWords(collectionModel);
  //     userWords.add(words as WordModel);
  //   }
  //   return userCollections;
  // }

  /// Get a single collection in collections
  Future<CollectionModel> fetchCollection() async {
    User? user = _firebaseAuth.currentUser;
    var doc = await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collections")
        .doc()
        .get();

    CollectionModel collectionModel = CollectionModel(name: doc.id);
    return collectionModel;
  }

  /// Fetch words for a specific collection
  Future<List<WordModel>> fetchWords(DocumentSnapshot doc) async {
    User? user = _firebaseAuth.currentUser;
    List<WordModel> words = [];

    try {
      var snapshot = await _userCollection
          .collection("users")
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
      await _userCollection
          .collection("users")
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
}
