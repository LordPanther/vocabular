import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/data/models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.defaultSize * .5),
        image: const DecorationImage(
          image: AssetImage(
            IMAGE_CONST.BACKGROUND_TWO,
          ),
          fit: BoxFit.cover,
        ),
      ),
      height: 150,
      child: Text(
        activity.id,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
