// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vocab_app/data/models/activity_model.dart';
// import 'package:vocab_app/data/repository/api_repository/api_repository.dart';
// import 'package:vocab_app/data/repository/activities_repository/firebase_activity_repo.dart';
// import 'package:vocab_app/data/repository/repository.dart';
// import 'package:vocab_app/presentation/screens/activity/bloc/bloc.dart';

// class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
//   APIRepository _apiRepository = AppRepository.apiRepository;
//   final FirebaseActivitiesRepository _activityRepository =
//       AppRepository.activitiesRepository;

//   ActivitiesBloc() : super(ActivitiesInitial()) {
//     on<LoadActivity>((event, emit) async {
//       await _mapLoadActivityToMap(event, emit);
//     });
//     // on<StartActivity>((event, emit) async {
//     //   await _mapStartActivityToMap(event, emit);
//     // });
//   }

//   Future<void> _mapLoadActivityToMap(
//       event, Emitter<ActivitiesState> emit) async {
//     emit(ActivityLoading());
//     try {
//       var activityData = await _activityRepository.getActivityData();
//       var activityResponse = ActivityResponse(activity: activityData);
//       emit(ActivityLoaded(activityResponse: activityResponse));
//     } on Exception catch (error) {
//       ActivityLoadFailure(error: error.toString());
//     }
//   }
// }

// class ActivityResponse {
//   final ActivityModel? activity;

//   ActivityResponse({this.activity});
// }
