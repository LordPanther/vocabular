import 'package:equatable/equatable.dart';
import 'package:vocab_app/presentation/screens/home_screen/home/home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Loading
class HomeLoading extends HomeState {}

/// Failure
class HomeLoadFailure extends HomeState {
  final String error;

  const HomeLoadFailure(this.error);
}