import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AddToCollection extends HomeEvent {
  final String collection;

  const AddToCollection({required this.collection});
}

class LoadCollections extends HomeEvent {}

class LoadHome extends HomeEvent {}

class RefreshHome extends HomeEvent {}
