import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class AddWord extends WordEvent {
  final WordModel word;
  final CollectionModel collection;
  final bool share;
  const AddWord(
      {required this.collection, required this.word, required this.share});

  @override
  List<Object> get props => [collection, word];
}

class LoadWordScreen extends WordEvent {}
