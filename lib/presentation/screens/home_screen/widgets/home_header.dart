import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/dialogs/form_dialog.dart';
import 'package:vocab_app/presentation/screens/home_screen/widgets/dialogs/popup_dialog.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  onOptionDialog(BuildContext context) async {
    final option = await showDialog(
      context: context,
      builder: (context) {
        return const SelectionDialog();
      },
    );
    if (option != null) {
      onFormDialog(context, option);
    }
  }

  onFormDialog(BuildContext context, String option) async {
    await showDialog(
      context: context,
      builder: (context) {
        return FormDialog(option: option);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.6),
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Colors.white, // Adjust as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {},
          ),
          Text(
            "Vocabula®",
            style: FONT_CONST.BOLD_PRIMARY_18,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => onOptionDialog(context),
          ),
        ],
      ),
    );
  }
}
