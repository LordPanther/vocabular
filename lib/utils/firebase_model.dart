// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vocab_app/data/models/add_word_model.dart';
// import 'package:vocab_app/data/models/models.dart';
// import 'package:vocab_app/utils/collection_data.dart';

// class FirebaseModel {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _userType;
//   final String _userId;

//   FirebaseModel(this._userType, this._userId);

//   Future<void> addWord(AddWordModel addWordModel) async {
//     try {
//       await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(addWordModel.collection.name)
//           .set({addWordModel.word.word: addWordModel.word.toMap()},
//               SetOptions(merge: true));
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> removeWord(CollectionModel collection, WordModel word) async {
//     try {
//       await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(collection.name)
//           .update({word.word: FieldValue.delete()});
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> addCollection(CollectionModel collection) async {
//     try {
//       await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(collection.name)
//           .set({});
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> removeCollection(CollectionModel collection) async {
//     try {
//       await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(collection.name)
//           .delete();
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> updateWord(WordModel updatedWord, CollectionModel collection) async {
//     try {
//       await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(collection.name)
//           .update({updatedWord.word: updatedWord.toMap()});
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<CollectionData> fetchCollections() async {
//     List<CollectionModel> userCollections = [];
//     List<List<WordModel>> userWords = [];

//     try {
//       var snapshot = await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .get();

//       for (var doc in snapshot.docs) {
//         CollectionModel collectionModel =
//             CollectionModel(name: doc.id);
//         userCollections.add(collectionModel);

//         List<WordModel> words = await fetchWords(doc);
//         userWords.add(words);
//       }
//     } catch (error) {
//       print(error);
//     }

//     return CollectionData(collections: userCollections, words: userWords);
//   }

//   Future<List<WordModel>> fetchWords(DocumentSnapshot doc) async {
//     List<WordModel> words = [];

//     try {
//       var snapshot = await _firestore
//           .collection(_userType)
//           .doc(_userId)
//           .collection("collections")
//           .doc(doc.id)
//           .get();

//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

//       data.forEach((key, value) {
//         words.add(WordModel(
//             id: value["id"],
//             definition: value["definition"],
//             audioUrl: value["audioUrl"],
//             word: key,
//             timeStamp: value["timeStamp"]));
//       });
//     } catch (error) {
//       print(error);
//     }

//     return words;
//   }
// }
