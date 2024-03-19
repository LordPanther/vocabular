import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var userCollection = FirebaseFirestore.instance;

  @override
  Future<List<CollectionsModel>> fetchWordCollections() {
    User? user = _firebaseAuth.currentUser;
    return userCollection
        .collection("collections/${user!.uid}/collections")
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => CollectionsModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
