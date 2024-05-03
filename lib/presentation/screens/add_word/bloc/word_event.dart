import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/add_word_model.dart';

class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class AddWord extends WordEvent {
  final AddWordModel word;
  const AddWord({required this.word});

  @override
  List<Object> get props => [word];
}

class LoadWordScreen extends WordEvent {}
