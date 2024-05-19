import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vocab_app/constants/audio_const.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/home_repository/home_repo.dart';
import 'package:vocab_app/data/repository/storage_repository/storage_repo.dart';
import 'package:vocab_app/utils/utils.dart';

class FirebaseHomeRepository implements HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageRepository _storageRepository = AppRepository.storageRepository;
  final _userHome = FirebaseFirestore.instance;
  User get user => _firebaseAuth.currentUser!;
  Future<List<List<String>>> get recentWords => getList();
  final AudioManager _audioManager = AudioManager();
  String get userType =>
      _firebaseAuth.currentUser!.isAnonymous ? "vocabguests" : "vocabusers";

  /// [FirebaseAuthRepository]
  /// Called once on registration to create collections:[defaultcollections]
  @override
  Future<void> createDefaultCollection() async {
    var audioUrl =
        await _audioManager.uploadDefaultAudio(user, AUDIO_CONST.defaultAudio);
    var vocabular = await WordsManager.instantiateModels(
      "default",
      "Vocabular",
      "The worlds best app for all those words you use everyday, everywhere.",
      audioUrl,
      "0000",
      true,
    );

    try {
      // Create default collection
      await addWord(vocabular.word);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// [CollectionsBloc]
  /// Add collection to collections
  @override
  Future<bool> addCollection(CollectionModel newCollection) async {
    // bool collectionExists = false;

    CollectionData collectionData = await fetchCollections();
    List<CollectionModel> collections = collectionData.collections;

    if (collections.contains(newCollection)) {
      return true;
    } else {
      await addColllectionToUi(newCollection);
    }
    return false;
  }

  @override
  Future<void> migrateGuestCollections(CollectionData data) async {
    for (var collection in data.collections) {
      await addCollection(collection);

      for (var word in data.words) {
        if (collection.name == word.id) {
          await addWord(word);
        }
      }
    }
  }

  @override
  Future<void> addWord(WordModel word) async {
    try {
      await _userHome
          .collection(userType)
          .doc(user.uid)
          .collection("collections")
          .doc(word.id)
          .set({word.word!: word.toMap()}, SetOptions(merge: true));
      if (!user.isAnonymous) {
        await updateRecentWordCache(word);
      }
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> updateRecentWordCache(WordModel newWord) async {
    List<List<String>> recentWords = await getList();
    saveList(newWord, recentWords);
  }

  Future<List<List<String>>> getList() async {
    String? jsonString = LocalPref.getString("recentWords");
    if (jsonString != null) {
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse.map((e) => List<String>.from(e)).toList();
    }
    return [];
  }

  Future<void> saveList(
      WordModel newWord, List<List<String>> recentWords) async {
    List<String> word = [
      newWord.id!.trim(),
      newWord.word!.trim(),
      newWord.definition!.trim(),
      newWord.audioUrl?.trim() ?? ""
    ];
    recentWords.add(word);
    String newJsonString = jsonEncode(recentWords);
    await LocalPref.setString("recentWords", newJsonString);
  }

  @override
  Future<void> removeWord(CollectionModel collection, WordModel word) async {
    try {
      await _userHome
          .collection(userType)
          .doc(user.uid)
          .collection("collections")
          .doc(collection.name)
          .update({word.word!: FieldValue.delete()});

      List<List<String>> recentWords = await getList();
      recentWords.removeWhere((list) => list.contains(word.word));

      String updatedRecentWords = jsonEncode(recentWords);
      await LocalPref.setString("recentWords", updatedRecentWords);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// Create collection
  Future<void> addColllectionToUi(CollectionModel collection) async {
    try {
      await _userHome
          .collection(userType)
          .doc(user.uid)
          .collection("collections")
          .doc(collection.name)
          .set({});
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  /// Get a list of collections in collections along with their words
  @override
  Future<CollectionData> fetchCollections() async {
    List<CollectionModel> userCollections = [];
    List<WordModel> userWords = [];
    var snapshot = await _userHome
        .collection(userType)
        .doc(user.uid)
        .collection("collections")
        .get();

    for (var doc in snapshot.docs) {
      CollectionModel collectionModel =
          CollectionModel(name: doc.id); //[0] = default, [1] = work
      userCollections.add(collectionModel);

      List<WordModel> words = await fetchWords(doc);
      for (var word in words) {
        userWords.add(word);
      }
    }
    return CollectionData(collections: userCollections, words: userWords);
  }

  /// Fetch words for a specific collection
  Future<List<WordModel>> fetchWords(DocumentSnapshot doc) async {
    List<WordModel> words = [];

    try {
      var snapshot = await _userHome
          .collection(userType)
          .doc(user.uid)
          .collection("collections")
          .doc(doc.id)
          .get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      data.forEach(
        (key, value) {
          words.add(WordModel(
              id: value["id"],
              definition: value["definition"],
              audioUrl: value["audioUrl"],
              word: key,
              timeStamp: value["timeStamp"]));
        },
      );
      return words; // Return the list of words here
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // Return an empty list in case of an error
      return words;
    }
  }

  @override
  Future<void> removeCollection(CollectionModel collection) async {
    try {
      await _userHome
          .collection(userType)
          .doc(user.uid)
          .collection("collections")
          .doc(collection.name)
          .delete();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Future<void> updateHomeData(AddWordModel newWord, WordModel oldWord) async {
    await _userHome
        .collection(userType)
        .doc(user.uid)
        .collection("collections")
        .doc(newWord.collection.name)
        .get()
        .then((doc) async {
      if (doc.exists) {
        // update
        await removeWord(newWord.collection, oldWord);
        await addWord(newWord.word);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
