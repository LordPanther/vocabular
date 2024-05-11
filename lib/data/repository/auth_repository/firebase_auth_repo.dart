import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocab_app/data/models/guest_user_model.dart';
import 'package:vocab_app/data/repository/guest_repository/guest_repo.dart';
import 'package:vocab_app/data/repository/guest_repository/firebase_guest_repo.dart';
import 'package:vocab_app/data/repository/home_repository/home_repo.dart';
import 'package:vocab_app/data/repository/home_repository/firebase_home_repo.dart';

import '../../models/user_model.dart';
import '../user_repository/firebase_user_repo.dart';
import '../user_repository/user_repo.dart';
import 'auth_repo.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = FirebaseUserRepository();
  final HomeRepository _homeRepository = FirebaseHomeRepository();
  final GuestRepository _guestRepository = FirebaseGuestRepository();
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
    if (kDebugMode) {
      print('Method: EmailPassword');
    }
    try {
      var userId = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      // Add ID for new user
      var updatedUserDetails = user.cloneWith(id: userId.user!.uid);
      // Create new doc in users collection
      await _userRepository.addUserData(updatedUserDetails);
      await create();
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  @override
  Future<void> switchUser(UserModel user, String password) async {
    if (kDebugMode) {
      print('Method: GuestToUser');
    }
    try {
      var credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      var userCredential =
          await loggedFirebaseUser.linkWithCredential(credential);

      // Add ID for new user

      if (userCredential.user != null) {
        var updatedUserDetails = user.cloneWith(id: userCredential.user!.uid);
        await _userRepository.addUserData(updatedUserDetails);
      }
      // Create new doc in users collection
      await create();
      await _guestRepository.removeGuestData(loggedFirebaseUser.uid);
    } on FirebaseAuthException catch (e) {
      // await loggedFirebaseUser.delete();
      await _userRepository.removeUserData(user);
      _authException = e.message.toString();
    }
  }

  @override
  Future<void> signUpAsGuest() async {
    if (kDebugMode) {
      print('Method: GuestSignIn');
    }
    try {
      UserCredential? guestId = await _firebaseAuth.signInAnonymously();
      GuestModel guestDetails = GuestModel(
          id: guestId.user!.uid, username: "guest${guestId.user!.uid}");

      await _guestRepository.addGuestData(guestDetails);
      await create();
    } on FirebaseAuthException catch (error) {
      _authException = error.message.toString();
    }
  }

  Future<void> create() async {
    try {
      await _homeRepository.createDefaultCollection();
    } catch (error) {
      _authException = "Failed to create default collection";
    }
  }

  /// If user is not logged in
  @override
  Future<void> resetPassword(String email) async {
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
      switch (e.toString()) {
        case "invalid-email":
          _authException =
              "We're sorry, but the email provided is invalid. Please double-check the email address and try again.";
          break;
        case "user-disabled":
          _authException =
              "Your account has been disabled. Please reach out to our support team for further assistance.";
          break;
        case "user-not-found":
          _authException =
              "We couldn't find an account associated with the provided email. Please make sure you've entered the correct email address or consider signing up if you haven't already.";
          break;
        case "wrong-password":
          _authException =
              "The password you entered is incorrect. Please ensure you're entering the correct password and try again. If you've forgotten your password, you can reset it through the 'Forgot Password' option.";
          break;
        default:
          "Something went wrong";
      }
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
    if (loggedFirebaseUser.isAnonymous) {
      var uid = loggedFirebaseUser.uid;
      await _guestRepository.removeGuestData(uid);
      await loggedFirebaseUser.delete().catchError((error) {
        if (kIsWeb) {
          if (kDebugMode) {
            print(error);
          }
        }
      });
      if (kDebugMode) {
        print("Guest deleted");
      }
    } else {
      await _firebaseAuth.signOut().catchError((error) {
        if (kIsWeb) {
          if (kDebugMode) {
            print(error);
          }
        }
      });
    }
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
