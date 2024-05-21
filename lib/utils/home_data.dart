import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/home/bloc/home_state.dart';

class HomeData {
  static List<CollectionModel> getCollections(HomeLoaded state) {
    return state.homeResponse.collections;
  }

  static List<WordModel> getWords(HomeLoaded state) {
    return state.homeResponse.words;
  }

  static WordModel getRecentWord(HomeLoaded state) {
    return state.homeResponse.recentWord!;
  }
}
