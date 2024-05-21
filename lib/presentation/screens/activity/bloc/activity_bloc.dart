import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/ai/ai_service.dart';
import 'package:vocab_app/data/models/activity_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/activities_repository/firebase_activities_repo.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/activity/bloc/bloc.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final FirebaseActivitiesRepository _activityRepository =
      AppRepository.activitiesRepository;
  final AIService _aiService = AIService();

  ActivitiesBloc() : super(ActivitiesInitial()) {
    on<LoadActivities>((event, emit) async {
      await _mapLoadActivitiesToMap(event, emit);
    });
    on<LoadActivity>((event, emit) async {
      await _mapLoadActivityToMap(event, emit);
    });
  }

  Future<void> _mapLoadActivitiesToMap(
      event, Emitter<ActivitiesState> emit) async {
    var activityData = await _activityRepository.getActivityData();

    ActivityResponse homeResponse = ActivityResponse(activities: activityData);
    emit(ActivitiesLoading(activityResponse: homeResponse));
  }

  Future<void> _mapLoadActivityToMap(
      event, Emitter<ActivitiesState> emit) async {
    var activity = event.activity;
    List<WordModel> wordData = [];
    if (activity.id == "swipecards") {
      wordData = await _aiService.getWordSwipeWords();
    } else {
      emit(const ActivitiesLoading(
          error: "This Activity is not available yet. Sorry!"));
    }

    ActivityResponse homeResponse =
        ActivityResponse(words: wordData, activity: activity);
    emit(ActivitiesLoaded(activityResponse: homeResponse));
  }
}

class ActivityResponse {
  final List<ActivityModel>? activities;
  final List<WordModel>? words;
  final ActivityModel? activity;

  ActivityResponse({this.activities, this.words, this.activity});
}
