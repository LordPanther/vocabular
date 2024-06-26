import 'package:vocab_app/data/models/activity_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

class CollectionData {
  List<CollectionModel> collections;
  List<WordModel> words;

  CollectionData({required this.collections, required this.words});

  List<CollectionModel> get passedCollections => collections;

  List<WordModel> get passedWords => words;
}

class ActivityData {
  List<ActivityModel> activities;

  ActivityData({required this.activities});

  List<ActivityModel> get passedActivities => activities;
}
