import 'package:equatable/equatable.dart';

/// Collections model
class CollectionModel extends Equatable {
  final String name;

  /// Constructor
  const CollectionModel({
    required this.name,
  });

  // Json data from server turns into model data
  static CollectionModel fromMap(Map<String, dynamic> data) {
    return CollectionModel(
      name: data["name"] ?? "",
    );
  }

  // From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name];
}
