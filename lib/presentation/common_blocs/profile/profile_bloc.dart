import 'dart:async';

import 'package:vocab_app/presentation/common_blocs/profile/bloc.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  final UserRepository _userRepository = AppRepository.userRepository;
  final StorageRepository _storageRepository = AppRepository.storageRepository;
  StreamSubscription? _profileStreamSub;
  UserModel? _loggedUser;

  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      await _mapLoadProfileToState(event, emit);
    });
    on<UploadAvatar>((event, emit) async {
      await _mapUploadAvatarToState(event, emit);
    });
    // on<AddressListChanged>((event, emit) async {
    //   await _mapAddressListChangedToState(event, emit);
    // });
    on<ProfileUpdated>((event, emit) async {
      await _mapProfileUpdatedToState(event, emit);
    });
  }

  /// Load Profile event => states
  Future<void> _mapLoadProfileToState(event, Emitter<ProfileState> emit) async {
    try {
      _profileStreamSub?.cancel();
      _profileStreamSub = _userRepository
          .loggedUserStream(_authRepository.loggedFirebaseUser)
          .listen((updatedUser) => add(ProfileUpdated(updatedUser)));
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  /// Upload Avatar event => states
  Future<void> _mapUploadAvatarToState(
      event, Emitter<ProfileState> emit) async {
    try {
      // Get image url from firebase storage
      String imageUrl = await _storageRepository.uploadImageFile(
        "vocabusers/profile/${_loggedUser!.id}",
        event.imageFile,
      );
      // Clone logged user with updated avatar
      var updatedUser = _loggedUser!.cloneWith(avatar: imageUrl);
      // Update user's avatar
      await _userRepository.updateUserData(updatedUser);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Profile Updated event => states
  Future<void> _mapProfileUpdatedToState(
      event, Emitter<ProfileState> emit) async {
    try {
      _loggedUser = event.updatedUser;
      emit(ProfileLoaded(event.updatedUser));
    } catch (e) {
      emit(ProfileLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _profileStreamSub?.cancel();
    _loggedUser = null;
    return super.close();
  }
}

// ignore: constant_identifier_names
enum ListMethod { ADD, DELETE, UPDATE }
