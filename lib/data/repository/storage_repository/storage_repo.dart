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

  Future<String> uploadAudioFile(String word, String ref, File file) async {
    SettableMetadata metadata = SettableMetadata(contentType: 'audio/mp3');
    var storageRef = storage.ref(ref).child('/$word.mp3');
    var uploadTask = await storageRef.putFile(file, metadata);

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

  ///Singleton factory
  static final StorageRepository _instance = StorageRepository._internal();

  factory StorageRepository() {
    return _instance;
  }

  StorageRepository._internal();
}
