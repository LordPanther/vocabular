import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/collections_bloc.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance;

  /// [FirebaseAuthRepository]
  /// Called once on registration to create collections:[defaultcollections]
  @override
  Future<void> createDefaultCollection(UserModel user) async {
    CollectionModel collection = const CollectionModel(
      name: "defaultcollection",
      id: "default",
    );

    try {
      await _userCollection
          .collection("users")
          .doc(user.id)
          .collection("collections")
          .doc(collection.id)
          .set(collection.toMap());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// [CollectionsBloc]
  /// Add collection to collections
  @override
  Future<void> createCollection(CollectionModel collection) async {
    User? user = _firebaseAuth.currentUser;

    List<CollectionModel> collections = await fetchCollections();

    for (var collection in collections) {
      String path = "users/${user!.uid}/collections/${collection.id}";
      bool collectionExists =
          await _userCollection.doc(path).get().then((value) => value.exists);

      if (!collectionExists) {
        await _userCollection.doc(path).set(collection.toMap());
        await addColllectionToUi(collection);
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
          .collection(collection.id)
          .doc()
          .set(collection.toMap());
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
        .collection("collections")
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      userCollections.add(CollectionModel.fromMap(data));
    }
    return userCollections;
  }

  @override
  Future<void> removeCollection(CollectionModel collection) {
    // TODO: implement removeCollection
    throw UnimplementedError();
  }
}
