import 'dart:io';
// import 'package:vocab_app/presentation/common_blocs/profile/bloc.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load profile of logged firebase user in firestore
class LoadProfile extends ProfileEvent {
  final String userType;

  LoadProfile(this.userType);
}

class UpdateUserDetails extends ProfileEvent {
  final UserModel updatedUserDetails;

  UpdateUserDetails(this.updatedUserDetails);

  @override
  List<Object> get props => [updatedUserDetails];
}

/// Upload user avatar
class UploadAvatar extends ProfileEvent {
  final File imageFile;

  UploadAvatar(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

/// Profile was updated
class ProfileUpdated extends ProfileEvent {
  final UserModel updatedUser;

  ProfileUpdated(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}
