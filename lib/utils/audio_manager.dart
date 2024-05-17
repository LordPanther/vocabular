import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/data/repository/storage_repository/storage_repo.dart';

class AudioManager {
  final AuthRepository _authRepository = AppRepository.authRepository;
  final StorageRepository _storageRepository = AppRepository.storageRepository;

  User? get user => _authRepository.currentUser;

  Future<String> storageData(User user, String? timeStamp) async {
    final fileName = "$timeStamp.m4a";
    String directoryPath = "/vocabusers/${user!.uid}";
    final storagePath = "$directoryPath/$fileName";
    return storagePath;
  }

  
}