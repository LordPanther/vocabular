import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';

class FirebaseCollectionsRepository implements CollectionsRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var wordsCollection = FirebaseFirestore.instance;

  // Create collection
  @override
  Future<void> createCollection(String collection) async {
    User? user = _firebaseAuth.currentUser;
    wordsCollection
        .collection("collections/${user!.uid}/$collection")
        .doc()
        .set({});
  }

  /// Method: fetches the list of all loggedIn users collections
  @override
  Stream<List<CollectionsModel>> fetchCollections(String uid) {
    return wordsCollection
        .collection("collections/$uid")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return CollectionsModel(id: "docid", name: doc.id);
            }).toList());
  }

  // @override
  // Future<void> addUserData(UserModel newUser) async {
  //   await _userCollection
  //       .doc(newUser.id)
  //       .set(newUser.toMap())
  //       // ignore: avoid_print
  //       .catchError((error) => print(error));
  // }

  // @override
  // Future<CollectionsModel> getCollectionById(String uid) async {
  //   return await wordsCollection
  //       .doc(uid)
  //       .get()
  //       .then((doc) => CollectionsModel.fromMap(doc.data()!))
  //       .catchError((error) {
  //     return error;
  //   });
  // }
}
