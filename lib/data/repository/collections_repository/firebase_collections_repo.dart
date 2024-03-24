import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userCollection = FirebaseFirestore.instance;

  /// Create collection if it does not exist
  @override
  Future<void> createCollection(String collection) async {
    User? user = _firebaseAuth.currentUser;
    
    try {
      _userCollection.collection(collection).doc(user!.uid).set({}).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

  }

  @override
  Future<void> updateCollections(String collection, WordModel wordData) async {
    User? user = _firebaseAuth.currentUser;
    _userCollection
        .collection(collection)
        .doc(user!.uid)
        .update(wordData as Map<Object, Object?> );
  }

  /// Fetch the list of all loggedIn users collections
  @override
  Stream<List<CollectionModel>> fetchCollections(String uid) {
    return 
  }

  /// Fetch specififc oggedIn users collection
  @override
  Stream<List<CollectionModel>> fetchCollection(String uid, String collection) {
    return 
  }
}
