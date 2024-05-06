import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  /// The current user's id.
  final String? id;

  /// The current user's email address.
  final String? email;

  /// The current user's first name (display name).
  final String? firstName;

  /// The current user's last name (display name).
  final String? lastName;

  /// Url for the current user's photo.
  final String? avatar;

  /// The user's phone number
  final String? username;

  /// Constructor
  const UserModel({
    this.email,
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.username
  });

  /// Json data from server turns into model data
  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data["id"] ?? "",
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      email: data["email"] ?? "",
      avatar: data["avatar"] ?? "",
      username: data["username"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "avatar": avatar,
      "username": username,
    };
  }

  /// Clone and update
  UserModel cloneWith({
    email,
    id,
    username,
    firstName,
    lastName,
    avatar,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
    );
  }

  @override
  String toString() {
    return "UserModel:{email:$email, firstName:$firstName,lastName:$lastName, username:$username, avatar:$avatar}";
  }

  /// Compare two users
  @override
  List<Object?> get props => [
        email,
        id,
        username,
        firstName,
        lastName,
        avatar,
      ];
}
