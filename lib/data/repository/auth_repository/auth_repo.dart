import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/user_model.dart';

abstract class AuthRepository {
  User get currentUser;
  bool get isAnonymous;
  String get authException;
  String get userId;

  Future<void> signUp(UserModel newUser, String password);

  Future<void> logInWithEmailAndPassword(String email, String password);

  Future<void> switchUser(UserModel user, String password);

  Future<void> signUpAsGuest();

  Future<void> verify();

  Future<void> resetPassword(String password);

  // Future<void> confirmPasswordReset(String code);

  Future<void> logInWithGoogle();

  Future<void> reloadUsers();

  bool isLoggedIn();
  bool isVerified();

  Future<void> logOut();
}
