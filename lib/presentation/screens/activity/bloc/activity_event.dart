import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/activity_model.dart';

class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class LoadActivities extends ActivitiesEvent {}

class LoadActivity extends ActivitiesEvent {
  final ActivityModel activity;
  const LoadActivity({required this.activity});

  @override
  List<Object> get props => [activity];
}
