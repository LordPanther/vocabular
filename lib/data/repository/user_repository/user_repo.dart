import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/user_model.dart';

abstract class UserRepository {
  Stream<UserModel> loggedUserStream(User loggedFirebaseUser);

  Future<void> addUserData(UserModel newUser);

  Future<void> removeUserData(UserModel userModel);

  Future<void> updateUserData(UserModel updatedUser);
}
