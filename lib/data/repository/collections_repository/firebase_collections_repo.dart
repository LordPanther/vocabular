import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/presentation/common_blocs/collections/collections_bloc.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance;

  /// [FirebaseAuthRepository]
  /// Called once on registration to create collections:[defaultcollections]
  @override
  Future<void> addCollectinData(UserModel user) async {
    CollectionModel collection = const CollectionModel(name: "defaultcollection", id: "defaultcollection");
    await _userCollection.collection("collections").doc(user.id).set(collection.toMap()).catchError((error) => (error));
  }

  /// [CollectionsBloc]
  /// Create collection if it does not exist
  @override
  Future<void> createCollection(List<CollectionModel> collections) async {
    User? user = _firebaseAuth.currentUser;

    for (var collection in collections) {
      String collectionId = collection.id;
      String path = "users/${user!.uid}/$collectionId";
      bool collectionExists = await _userCollection.doc(path).get().then((value) => value.exists);

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
        await doc.reference.update(updatedCollection.toMap());
      }
    }).catchError((error) {});
  }

  /// Delete a collection from list collections:[collections]
  @override
  Future<void> removeCollection() async {
    User? user = _firebaseAuth.currentUser;
    await _userCollection
        .doc(user!.uid)
        .delete()
    // ignore: avoid_print
        .catchError((error) => print(error));
  }

  /// [CollectionsBloc]
  /// A list of collections created by user collections: [collections]
  @override
  Stream<List<CollectionModel>> fetchCollections(
      String uid, String collection) {
    StreamController<List<CollectionModel>> controller =
        StreamController<List<CollectionModel>>();

    List<CollectionModel> userCollection = [];

    var collections = _userCollection
        .doc(uid)
        .collection(collection)
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            var data = doc.data();
            userCollection.add(CollectionModel.fromMap(data));
          }
    });

    return controller.stream;
  }

  /// The list of collections to display on UI
  @override
  Future<List<CollectionModel>> fetchUserCollections() async {
    List<CollectionModel> userCollections = [];
    return userCollections;
  }

  @override
  Future<void> updateCollections(String collection, WordModel wordData) {
    // TODO: implement updateCollections
    throw UnimplementedError();
  }
}
