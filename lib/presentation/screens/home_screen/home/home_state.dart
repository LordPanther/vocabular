import 'package:equatable/equatable.dart';

import 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final HomeResponse homeResponse;

  const HomeLoaded({required this.homeResponse});

  @override
  List<Object?> get props => [homeResponse];
}

class CollectionExists extends HomeState {}

/// Home Load State
class HomeLoading extends HomeState {}

/// Home Load Failure
class HomeLoadFailure extends HomeState {
  final String error;

  const HomeLoadFailure(this.error);
}
