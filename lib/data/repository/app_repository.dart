import 'package:vocab_app/data/repository/collections_repository/firebase_collections_repo.dart';
import 'package:vocab_app/data/repository/feedback_repository/firebase_feedback_repo.dart';
import 'package:vocab_app/data/repository/storage_repository/storage_repo.dart';
import 'package:vocab_app/data/repository/user_repository/firebase_user_repo.dart';
import 'package:vocab_app/data/repository/word_repository/firebase_word_repo.dart';

import 'auth_repository/firebase_auth_repo.dart';

class AppRepository {
  /// Repository
  static final authRepository = FirebaseAuthRepository();
  static final userRepository = FirebaseUserRepository();
  static final feedbackRepository = FirebaseFeedbackRepository();
  static final wordRepository = FirebaseWordRepository();
  static final storageRepository = StorageRepository();
  static final collectionsRepository = FirebaseCollectionsRepository();

  /// Singleton factory
  static final AppRepository _instance = AppRepository._internal();

  factory AppRepository() {
    return _instance;
  }
  AppRepository._internal();
}
