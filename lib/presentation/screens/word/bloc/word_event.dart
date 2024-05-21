import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/addword_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class AddWord extends WordEvent {
  final AddWordModel word;
  final bool isEditing;
  const AddWord({required this.word, required this.isEditing});

  @override
  List<Object> get props => [word];
}

class UpdateWord extends WordEvent {
  final AddWordModel updatedWord;
  final WordModel oldWord;
  const UpdateWord({required this.updatedWord, required this.oldWord});

  @override
  List<Object> get props => [updatedWord, oldWord];
}

class LoadWordScreen extends WordEvent {}
