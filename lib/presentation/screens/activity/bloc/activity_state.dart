import 'package:equatable/equatable.dart';
import 'package:vocab_app/presentation/screens/activity/bloc/activity_bloc.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object?> get props => [];
}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {
  final String? error;
  final ActivityResponse? activityResponse;

  const ActivitiesLoading({this.error, this.activityResponse});

  @override
  List<Object?> get props => [activityResponse];
}

class ActivitiesLoaded extends ActivitiesState {
  final ActivityResponse activityResponse;

  const ActivitiesLoaded({required this.activityResponse});

  @override
  List<Object?> get props => [activityResponse];
}

class ActivityLoadFailure extends ActivitiesState {
  final String error;

  const ActivityLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
