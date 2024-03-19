import 'package:equatable/equatable.dart';

/// Cart item model
class CollectionsModel extends Equatable {
  /// Collection id
  final String id;

  /// Product Id
  final String collection;

  /// Constructor
  const CollectionsModel({
    required this.id,
    required this.collection,
  });

  /// Json data from server turns into model data
  static CollectionsModel fromMap(String id, Map<String, dynamic> data) {
    return CollectionsModel(
      id: data["id"] ?? "",
      collection: data["word"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "word": collection,
    };
  }

  @override
  String toString() {
    return collection;
  }

  @override
  List<Object?> get props => [id, collection];
}
