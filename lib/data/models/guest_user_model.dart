import 'package:equatable/equatable.dart';

/// User model
class GuestModel extends Equatable {
  /// The current user's id.
  final String id;

  // The guest users username.
  final String? username;

  /// Constructor
  const GuestModel({
    required this.id,
    this.username,
  });

  /// Json data from server turns into model data
  static GuestModel fromMap(Map<String, dynamic> data) {
    return GuestModel(
      id: data["id"] ?? "",
      username: data["username"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
    };
  }

  /// Clone and update
  GuestModel cloneWith({
    id,
    username,
    email,
  }) {
    return GuestModel(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  @override
  String toString() {
    return "GuestModel:{id:$id, username:$username}";
  }

  /// Compare two users
  @override
  List<Object?> get props => [
        id,
        username,
      ];
}
