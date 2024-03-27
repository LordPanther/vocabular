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
  Future<void> addCollectionData(UserModel user) async {
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
  /// Create collection if it does not exist
  @override
  Future<void> createCollection(List<CollectionModel> collections) async {
    User? user = _firebaseAuth.currentUser;

    for (var collection in collections) {
      String path = "users/${user!.uid}/collections/${collection.id}";
      bool collectionExists =
          await _userCollection.doc(path).get().then((value) => value.exists);

      if (!collectionExists) {
        await _userCollection.doc(path).set(collection.toMap());
      } else {
        continue;
      }
    }
  }

  /// Add another collection to the list of collections:[collections]
  @override
  Future<void> addColllectionToList(CollectionModel updatedCollection) async {
    User? user = _firebaseAuth.currentUser;
    await _userCollection.doc(user!.uid).get().then((doc) async {
      if (doc.exists) {
        // update
        // await doc.reference.update(updatedCollection.toMap());
        return;
      } else {
        String path = "users/${user.uid}/collections/${updatedCollection.id}";
        await _userCollection.doc(path).set(updatedCollection.toMap());
      }
    }).catchError((error) {});
  }

  /// The list of collections to display on UI
  @override
  Future<List<CollectionModel>> fetchUserCollections() async {
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
}
