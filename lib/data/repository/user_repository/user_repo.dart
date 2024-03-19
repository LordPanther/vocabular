import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

abstract class UserRepository {
  Stream<UserModel> loggedUserStream(User loggedFirebaseUser);

  Future<UserModel> getUserById(String uid);

  Future<void> addUserData(UserModel newUser);

  Future<void> removeUserData(UserModel userModel);

  Future<void> updateUserData(UserModel updatedUser);
}
