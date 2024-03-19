import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  /// The current user's id.
  final String id;

  /// The current user's email address.
  final String email;

  /// The current user's first name (display name).
  final String firstName;

  /// The current user's last name (display name).
  final String lastName;

  /// Url for the current user's photo.
  final String avatar;

  /// The user's phone number
  final String phoneNumber;

  /// The users verification status
  final String verificationStatus;

  /// The users verification status
  final String tier;

  /// Constructor
  const UserModel({
    required this.email,
    required this.id,
    required this.tier,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.phoneNumber,
    required this.verificationStatus,
  });

  /// Json data from server turns into model data
  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data["id"] ?? "",
      tier: data["tier"] ?? "",
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      email: data["email"] ?? "",
      avatar: data["avatar"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      verificationStatus: data["verificationStatus"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "tier": tier,
      "firstName": firstName,
      "lastName": lastName,
      "avatar": avatar,
      "phoneNumber": phoneNumber,
      "verificationStatus": verificationStatus,
    };
  }

  /// Clone and update
  UserModel cloneWith({
    email,
    id,
    tier,
    phoneNumber,
    verificationStatus,
    firstName,
    lastName,
    avatar,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      tier: tier ?? this.tier,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  String toString() {
    return "UserModel:{email:$email, firstName:$firstName, tier:$tier ,lastName:$lastName, phoneNumber:$phoneNumber, avatar:$avatar}";
  }

  /// Compare two users
  @override
  List<Object?> get props => [
        email,
        id,
        tier,
        firstName,
        lastName,
        avatar,
        phoneNumber,
        verificationStatus,
      ];
}
