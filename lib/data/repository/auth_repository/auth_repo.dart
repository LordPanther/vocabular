import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

abstract class AuthRepository {
  User get loggedFirebaseUser;
  String get authException;

  Future<void> signUp(UserModel newUser, String password);

  Future<void> logInWithEmailAndPassword(String email, String password);

  Future<void> verify();

  Future<void> resetPassword(String password);

  // Future<void> confirmPasswordReset(String code);

  Future<void> logInWithGoogle();

  Future<void> reloadUsers();

  bool isLoggedIn();
  bool isVerified();

  Future<void> logOut();
}
