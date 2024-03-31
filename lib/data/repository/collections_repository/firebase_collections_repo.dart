import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';

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
        id: user.id,
        definition:
            "The worlds best app for all those words you use everyday, everywhere.",
        word: "vocabular");

    try {
      // Create collections array
      await writeToCollectionsArray(collection);

      // Create default collection
      await addWordToCollection(collection, word);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// [CollectionsBloc]
  /// Add collection to collections
  @override
  Future<void> createCollection(CollectionModel newCollection) async {
    User? user = _firebaseAuth.currentUser;
    var snapshot = await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collectionsbucket")
        .doc("bucket")
        .get();

    if (snapshot.exists) {
      List<dynamic> collectionsArray = snapshot.data()!["collections"];
      // var collectionsList =
      //     collectionsArray.cast<String>().toList(growable: true);

      if (collectionsArray.contains(newCollection.name)) {
        return;
      } else {
        await writeToCollectionsArray(newCollection);
        await addColllectionToUi(newCollection);
      }
    }
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
      CollectionModel collection, WordModel word) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await _userCollection
          .collection("users")
          .doc(user!.uid)
          .collection("collections")
          .doc(collection.name)
          .set({
        word.word: {word.toMap()}
      });
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

  /// Get a list of collections in collections
  @override
  Future<List<CollectionModel>> fetchCollections() async {
    User? user = _firebaseAuth.currentUser;
    List<CollectionModel> userCollections = [];
    var snapshot = await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collectionsbucket")
        .get();

    for (var doc in snapshot.docs) {
      var collectionName = doc.data()["name"];
      CollectionModel collectionModel = CollectionModel(name: collectionName);
      userCollections.add(collectionModel);
    }
    return userCollections;
  }

  /// Fetch words for a specific collection
  Future<List<WordModel>> fetchWords(CollectionModel collection) async {
    User? user = _firebaseAuth.currentUser;
    List<WordModel> words = [];
    var snapshot = await _userCollection
        .collection("users")
        .doc(user!.uid)
        .collection("collections")
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      var collectionsData = List<WordModel>.from(data[collection.name]);

      for (var wordData in collectionsData) {
        var word = WordModel.fromMap(wordData as Map<String, dynamic>);
        words.add(word);
      }
    }
    return words;
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
