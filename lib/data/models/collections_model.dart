import 'package:equatable/equatable.dart';

/// Collections model
class CollectionsModel extends Equatable {
  final String id;
  final String name;

  /// Constructor
  const CollectionsModel({
    required this.id,
    required this.name,
  });

  // Json data from server turns into model data
  static CollectionsModel fromMap(String uid, Map<String, dynamic> data) {
    return CollectionsModel(
      id: data["id"] ?? uid,
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
    return name;
  }

  @override
  List<Object?> get props => [id, name];
}
