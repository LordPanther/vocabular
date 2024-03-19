import 'package:flutter/cupertino.dart';
import 'package:vocab_app/presentation/common_blocs/auth/bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/presentation/screens/profile/profile_header.dart';
import 'package:vocab_app/presentation/widgets/others/custom_list_tile.dart';
import 'package:vocab_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            _buildProfileMenuButton(
              text: Translate.of(context).translate("profile"),
              icon: Icon(CupertinoIcons.profile_circled,
                  size: SizeConfig.defaultSize * 3),
              onPressed: () {},
            ),
            _buildProfileMenuButton(
              text: Translate.of(context).translate("my_orders"),
              icon: Icon(CupertinoIcons.square_list,
                  size: SizeConfig.defaultSize * 3),
              onPressed: () {},
            ),
            _buildProfileMenuButton(
              text: Translate.of(context).translate("delivery_address"),
              icon: Icon(CupertinoIcons.map, size: SizeConfig.defaultSize * 3),
              onPressed: () {},
            ),
            _buildProfileMenuButton(
              text: Translate.of(context).translate("log_out"),
              icon: Icon(CupertinoIcons.return_icon,
                  size: SizeConfig.defaultSize * 3),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildProfileMenuButton({
    required String text,
    required Icon icon,
    required Function() onPressed,
  }) {
    return CustomListTile(
      leading: icon,
      title: text,
      onPressed: onPressed,
      trailing:
          const Icon(Icons.arrow_forward_ios, color: COLOR_CONST.textColor),
    );
  }
}
