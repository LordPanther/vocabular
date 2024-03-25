import 'dart:async';

import 'package:vocab_app/data/repository/user_repository/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/presentation/widgets/single_card/collections_card.dart';

import '../../models/user_model.dart';

class FirebaseUserRepository implements UserRepository {
  final _userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Stream<UserModel> loggedUserStream(User loggedFirebaseUser) {
    return _userCollection
        .doc(loggedFirebaseUser.uid)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data()!));
  }

  @override
  Future<UserModel> getUserById(String uid) async {
    return await _userCollection
        .doc(uid)
        .get()
        .then((doc) => UserModel.fromMap(doc.data()!))
        .catchError((error) {
      return error;
    });
  }

  @override
  Future<void> addUserData(
      UserModel newUser) async {
    await _userCollection
        .doc(newUser.id)
        .set(newUser.toMap())
        // ignore: avoid_print
        .catchError((error) => print(error));
  }

  @override
  Future<void> removeUserData(UserModel newUser) async {
    await _userCollection
        .doc(newUser.id)
        .delete()
        // ignore: avoid_print
        .catchError((error) => print(error));
  }

  @override
  Future<void> updateUserData(UserModel updatedUser) async {
    await _userCollection.doc(updatedUser.id).get().then((doc) async {
      if (doc.exists) {
        // update
        await doc.reference.update(updatedUser.toMap());
      }
    }).catchError((error) {});
  }

  ///Singleton factory
  static final FirebaseUserRepository _instance =
      FirebaseUserRepository._internal();

  factory FirebaseUserRepository() {
    return _instance;
  }

  FirebaseUserRepository._internal();
}
