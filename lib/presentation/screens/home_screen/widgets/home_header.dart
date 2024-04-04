import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/collections_model.dart';

class HomeHeader extends StatelessWidget {
  final List<CollectionModel> collections;

  const HomeHeader({super.key, required this.collections});

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
            icon: const Icon(CupertinoIcons.profile_circled),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.PROFILE);
            },
          ),
          Text(
            "Vocabula®",
            style: FONT_CONST.BOLD_PRIMARY_18,
          ),
          IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: () => Navigator.pushNamed(
                  context, AppRouter.SEARCH) //_onOptionDialog(context),
              ),
        ],
      ),
    );
  }
}
