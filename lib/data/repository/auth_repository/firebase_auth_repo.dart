import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocab_app/data/repository/collections_repository/collections_repo.dart';
import 'package:vocab_app/data/repository/collections_repository/firebase_collections_repo.dart';

import '../../models/user_model.dart';
import '../user_repository/firebase_user_repo.dart';
import '../user_repository/user_repo.dart';
import 'auth_repo.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = FirebaseUserRepository();
  final CollectionsRepository _collectionsRepository =
      FirebaseCollectionsRepository();
  // final UserModel user;

  String _authException = "Authentication Failure";

  @override
  User get loggedFirebaseUser => _firebaseAuth.currentUser!;

  @override
  String get authException => _authException;

  @visibleForTesting
  bool isWeb = kIsWeb;

  /// Don't use onAuthChange

  @override
  Future<void> signUp(UserModel user, String password) async {
    try {
      var userId = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      // Add ID for new user
      var updatedUserDetails = user.cloneWith(id: userId.user!.uid);
      // Create new doc in users collection
      await _userRepository.addUserData(updatedUserDetails);
      await _collectionsRepository.addCollectionData(updatedUserDetails);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  /// If user is not logged in
  @override
  Future<void> resetPassword(String email) async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String packageName = packageInfo.packageName;

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  @override
  Future<void> verify() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.sendEmailVerification();
      }
      if (kDebugMode) {
        print("VerificationState: Verification email sent");
      }
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  @override
  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  @override
  Future<void> logInWithGoogle() async {
    if (kDebugMode) {
      print('Method: GoogleSignIn()');
    }
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  @override
  bool isVerified() => _firebaseAuth.currentUser!.emailVerified;

  @override
  bool isLoggedIn() => _firebaseAuth.currentUser != null;

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut().catchError((error) {
      if (kIsWeb) {
        if (kDebugMode) {
          print(error);
        }
      }
    });
  }

  @override
  Future<void> reloadUsers() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  ///Singleton factory
  static final FirebaseAuthRepository _instance =
      FirebaseAuthRepository._internal();

  factory FirebaseAuthRepository() {
    return _instance;
  }

  FirebaseAuthRepository._internal();
}
