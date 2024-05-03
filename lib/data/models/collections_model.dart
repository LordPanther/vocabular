import 'package:equatable/equatable.dart';

/// Collections model
class CollectionModel extends Equatable {
  final String? id;
  final String? name;

  /// Constructor
  const CollectionModel({
    this.id,
    this.name,
  });

  // Json data from server turns into model data
  static CollectionModel fromMap(Map<String, dynamic> data) {
    return CollectionModel(
      id: data["id"] ?? "",
      name: data["name"] ?? "",
    );
  }

  // From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  CollectionModel cloneWith({
    id,
    name,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return "CollectionModel:{id:$id, name:$name}";
  }

  @override
  List<Object?> get props => [name];
}
