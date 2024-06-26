import 'package:vocab_app/data/repository/api_repository/api_repository.dart';
import 'package:vocab_app/data/repository/guest_repository/firebase_guest_repo.dart';
import 'package:vocab_app/data/repository/home_repository/firebase_home_repo.dart';
import 'package:vocab_app/data/repository/feedback_repository/firebase_feedback_repo.dart';
import 'package:vocab_app/data/repository/storage_repository/storage_repo.dart';
import 'package:vocab_app/data/repository/user_repository/firebase_user_repo.dart';

import 'auth_repository/firebase_auth_repo.dart';

class AppRepository {
  /// Repository
  static final authRepository = FirebaseAuthRepository();
  static final userRepository = FirebaseUserRepository();
  static final guestRepository = FirebaseGuestRepository();
  static final feedbackRepository = FirebaseFeedbackRepository();
  static final storageRepository = StorageRepository();
  static final collectionsRepository = FirebaseHomeRepository();
  // static final activitiesRepository = FirebaseActivitiesRepository();
  static final apiRepository = APIRepository();

  /// Singleton factory
  static final AppRepository _instance = AppRepository._internal();

  factory AppRepository() {
    return _instance;
  }
  AppRepository._internal();
}
