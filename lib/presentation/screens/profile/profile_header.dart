import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/models.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_event.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_state.dart';
import 'package:vocab_app/presentation/widgets/buttons/circle_icon_button.dart';
import 'package:vocab_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:vocab_app/utils/translate.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({
    super.key,
  });

  final ImagePickerPlatform picker = ImagePickerPlatform.instance;
  late final XFile? file;

  void onUploadAvatar(BuildContext context) async {
    File? imageFile;
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
    } else {
      // ignore: use_build_context_synchronously
      UtilSnackBar.showSnackBarContent(context,
          // ignore: use_build_context_synchronously
          content: Translate.of(context).translate('no_image'));
    }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.defaultSize * 30,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return FutureBuilder(
              future: retrieveLostData(),
              builder: ((context, snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfilePicture(context, state.loggedUser),
                    SizedBox(height: SizeConfig.defaultSize * 3),
                    Text(
                      "${state.loggedUser.firstName} ${state.loggedUser.lastName}",
                      style: FONT_CONST.BOLD_DEFAULT_18,
                      softWrap: true,
                    )
                  ],
                );
              }),
            );
          }
          return Center(
              child: Text(Translate.of(context).translate('error_one')));
        },
      ),
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
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: CircleAvatar(
            backgroundImage: loggedUser.avatar.isNotEmpty
                ? NetworkImage(loggedUser.avatar)
                : const AssetImage(IMAGE_CONST.DEFAULT_AVATAR)
                    as ImageProvider<Object>,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleIconButton(
            onPressed: () => onUploadAvatar(context),
            svgIcon: ICON_CONST.ADD,
            color: COLOR_CONST.cardShadowColor,
            size: SizeConfig.defaultSize * 2,
          ),
        )
      ],
    );
  }
}
