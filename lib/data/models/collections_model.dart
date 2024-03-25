import 'package:equatable/equatable.dart';

/// Collections model
class CollectionModel extends Equatable {
  final String name;
  final  String id;

  /// Constructor
  const CollectionModel({
    required this.name,
    required this.id,
  });

  // Json data from server turns into model data
  static CollectionModel fromMap(Map<String, dynamic> data) {
    return CollectionModel(
      id: data["id"] ?? "default",
      name: data["name"] ?? "defaultcollection",
    );
  }

  // From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() {
    return id;
  }

  @override
  List<Object?> get props => [id];
}
