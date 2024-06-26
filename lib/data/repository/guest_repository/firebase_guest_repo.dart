import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/guestuser_model.dart';
import 'package:vocab_app/data/repository/guest_repository/guest_repo.dart';

class FirebaseGuestRepository implements GuestRepository {
  final _guestCollection = FirebaseFirestore.instance.collection("vocabguests");

  @override
  Stream<GuestModel> loggedGuestStream(User loggedFirebaseUser) {
    return _guestCollection
        .doc(loggedFirebaseUser.uid)
        .snapshots()
        .map((doc) => GuestModel.fromMap(doc.data()!));
  }

  @override
  Future<void> addGuestData(GuestModel newGuest) async {
    await _guestCollection
        .doc(newGuest.id)
        .set(newGuest.toMap())
        // ignore: avoid_print
        .catchError((error) => print(error));
  }

  @override
  Future<void> removeGuestData(String uid) async {
    await _guestCollection
        .doc(uid)
        .delete()
        // ignore: avoid_print
        .catchError((error) => print(error));
  }


  ///Singleton factory
  static final FirebaseGuestRepository _instance =
      FirebaseGuestRepository._internal();

  factory FirebaseGuestRepository() {
    return _instance;
  }

  FirebaseGuestRepository._internal();
}
