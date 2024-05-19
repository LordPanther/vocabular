import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/storage_repository/storage_repo.dart';

class AudioManager {
  final StorageRepository _storageRepository = AppRepository.storageRepository;

  Future startRecording(
      bool isRecorderReady, FlutterSoundRecorder recorder) async {
    var path = await getRecordigPath();
    if (!isRecorderReady) return "";
    await recorder.startRecorder(toFile: path);
  }

  Future stopRecording(
      bool isRecorderReady, FlutterSoundRecorder recorder) async {
    if (!isRecorderReady) return "";
    return await recorder.stopRecorder();
  }

  ///Get Language Global Language Name
  Future<String> storageData(User user, String? timeStamp) async {
    final fileName = "$timeStamp.mp3";
    String directoryPath = "/vocabusers/${user.uid}";
    final storagePath = "$directoryPath/$fileName";
    return storagePath;
  }

  Future<String> uploadAudioData(
      User? user, String? timeStamp, String? path) async {
    var storagePath = await storageData(user!, timeStamp);
    var fileData = await getUint8ListFromLocalPath(path!);

    var audioUrl = await _storageRepository.uploadAudioData(
      storagePath,
      fileData!,
    );
    if (audioUrl.isNotEmpty) {
      return audioUrl;
    }
    return "";
  }

  Future<Uint8List?> getUint8ListFromLocalPath(String localPath) async {
    if (localPath.isEmpty) {
      return null;
    }
    try {
      final file = File(localPath);
      return await file.readAsBytes();
    } catch (error) {
      if (kDebugMode) {
        print('Error reading file: $error');
      }
      return null;
    }
  }

  Future<String> uploadDefaultAudio(User user, String assetPath) async {
    final Directory systemTempDir = Directory.systemTemp;
    String? timeStamp = "${DateTime.now().millisecondsSinceEpoch}";
    var storagePath = await storageData(user, timeStamp);

    if (assetPath.isEmpty) {
      return "";
    }
    try {
      final byteData = await rootBundle.load(assetPath);
      final file = File("${systemTempDir.path}/$timeStamp.mp3");
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return await _storageRepository.uploadAudioFile(storagePath, file);
    } catch (error) {
      if (kDebugMode) {
        print('Error reading file: $error');
      }
      return "";
    }
  }

  Future<String> getRecordigPath() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String recordingPath = '${appDocumentsDir.path}/tempRecording';
    final existingFile = File(recordingPath);
    if (existingFile.existsSync()) {
      existingFile.deleteSync();
    }
    return recordingPath;
  }

  Future clearCache(String? path) async {
    if (path!.isNotEmpty) {
      var tempFile = File(path);
      if (tempFile.existsSync()) {
        tempFile.delete();
      }
    }
  }
}
