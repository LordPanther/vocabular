import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/constants/icon_constant.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_event.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_event.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/circle_icon_button.dart';
import 'package:vocab_app/presentation/widgets/buttons/text_button.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/utils/dialog.dart';
import 'package:vocab_app/utils/translate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePickerPlatform picker = ImagePickerPlatform.instance;
  File? imageFile;
  late final XFile? file;

  @override
  void initState() {
    super.initState();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      file = response.file;
    }
  }

  void onUploadAvatar(BuildContext context, UserModel user) async {
    File? imageFile;

    if (user.avatar != null) {
      var file = await picker.getImageFromSource(
          source: ImageSource.gallery,
          options: const ImagePickerOptions(
            maxWidth: 480,
            maxHeight: 680,
            imageQuality: 50,
          ));

      if (file != null) {
        imageFile = File(file.path);
        // ignore: use_build_context_synchronously
        BlocProvider.of<ProfileBloc>(context).add(UploadAvatar(imageFile));
      }
    } else {
      bool signUp = await UtilDialog.showGuestDialog(
          context: context, content: Translate.of(context).translate('switch'));

      if (signUp) {
        Navigator.of(context).pushNamed(AppRouter.SWITCH_USER);
      }
    }
  }

  void onEditUserDetails(ProfileLoaded state) async {
    var updatedDetails =
        await UtilDialog.updateUserDetails(context: context, state: state);

    if (updatedDetails!.email != null) {
      BlocProvider.of<ProfileBloc>(context)
          .add(UpdateUserDetails(updatedDetails));
    }
  }

  void onLogout() {
    BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Loading();
          }
          if (state is ProfileLoaded) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.defaultSize * 5),
                      _buildProfileHeader(state),
                      _profileBody(state),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is ProfileLoadFailure) {
            return Center(
              child: Text(Translate.of(context).translate("fall_back_error")),
            );
          }
          return Center(
            child: Text(Translate.of(context).translate("fall_back_error")),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileLoaded state) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.defaultSize * 30,
      child: FutureBuilder(
        future: retrieveLostData(),
        builder: ((context, snapshot) {
          return Center(
            child: _buildProfilePicture(context, state.loggedUser),
          );
        }),
      ),
    );
  }

  Widget _profileBody(ProfileLoaded state) {
    var user = state.loggedUser;
    var userDetails = [
      user.username,
      "${user.firstname} ${user.lastname}",
      user.email,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultSize * 3,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => onEditUserDetails(state),
                icon: const Icon(CupertinoIcons.pen),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.defaultSize * 3),
          ListView.builder(
            shrinkWrap: true,
            itemCount: userDetails.length,
            itemBuilder: (context, index) {
              final detail = userDetails[index];
              return detail != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(detail),
                        SizedBox(height: SizeConfig.defaultSize * 2),
                      ],
                    )
                  : const SizedBox.shrink(); // Skips null values
            },
          ),
          SizedBox(height: SizeConfig.defaultSize * 5),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  _buildLogoutButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextButton(
          onPressed: onLogout,
          buttonName: Translate.of(context).translate('log_out'),
          buttonStyle: FONT_CONST.MEDIUM_DEFAULT_18,
        ),
      ],
    );
  }

  _buildProfilePicture(BuildContext context, UserModel loggedUser) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: SizeConfig.defaultSize * 15,
          width: SizeConfig.defaultSize * 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: COLOR_CONST.primaryColor.withOpacity(0.3), width: 2),
          ),
          child: CircleAvatar(
            backgroundImage: loggedUser.avatar != null
                ? NetworkImage(loggedUser.avatar!)
                : const AssetImage(IMAGE_CONST.DEFAULT_AVATAR)
                    as ImageProvider<Object>,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleIconButton(
            onPressed: () => onUploadAvatar(context, loggedUser),
            svgIcon: ICON_CONST.CAMERA,
            color: COLOR_CONST.cardShadowColor,
            size: SizeConfig.defaultSize * 2,
          ),
        )
      ],
    );
  }
}
