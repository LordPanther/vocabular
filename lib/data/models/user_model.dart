import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  /// The current user's id.
  final String? id;

  /// The current user's email address.
  final String? email;

  /// The current user's first name (display name).
  final String? firstname;

  /// The current user's last name (display name).
  final String? lastname;

  /// Url for the current user's photo.
  final String? avatar;

  /// The user's phone number
  final String? username;

  final Map<String, dynamic>? activities;

  /// Constructor
  const UserModel(
      {this.email,
      this.id,
      this.firstname,
      this.lastname,
      this.avatar,
      this.username,
      this.activities});

  /// Json data from server turns into model data
  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data["id"] ?? "",
      firstname: data["firstName"] ?? "",
      lastname: data["lastName"] ?? "",
      email: data["email"] ?? "",
      avatar: data["avatar"] ?? "",
      username: data["username"] ?? "",
      activities: data["activities"] ?? {},
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "firstName": firstname,
      "lastName": lastname,
      "avatar": avatar,
      "username": username,
      "activities": activities,
    };
  }

  /// Clone and update
  UserModel cloneWith({
    email,
    id,
    username,
    firstname,
    lastname,
    avatar,
    activities,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      activities: activities ?? this.activities,
    );
  }

  @override
  String toString() {
    return "UserModel:{email:$email, firstName:$firstname,lastName:$lastname, username:$username, avatar:$avatar, activities:$activities}";
  }

  /// Compare two users
  @override
  List<Object?> get props => [
        email,
        id,
        username,
        firstname,
        lastname,
        avatar,
        activities,
      ];
}
