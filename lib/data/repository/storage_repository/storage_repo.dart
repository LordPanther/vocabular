import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  static const String bucketRef = "gs://blackworks-educational.appspot.com";
  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: bucketRef);

  /// Return image URL
  Future<String> uploadImageFile(String ref, File file) async {
    Reference storageRef = storage.ref().child(ref);
    var uploadTask = await storageRef.putFile(file);

    String downloadURL = await uploadTask.ref.getDownloadURL();
    return downloadURL;
  }

  /// Return audio URL for sharing with other users
  Future<String> uploadAudioData(String ref, Uint8List fileData) async {
    var storageRef = storage.ref(ref);
    var uploadTask = await storageRef.putData(fileData);

    String downloadURL = await uploadTask.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadAudioFile(String storagePath, File file) async {
    var taskSnapshot = await storage.ref(storagePath).putFile(file);

    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  ///Singleton factory
  static final StorageRepository _instance = StorageRepository._internal();

  factory StorageRepository() {
    return _instance;
  }

  StorageRepository._internal();
}
