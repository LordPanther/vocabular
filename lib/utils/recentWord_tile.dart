import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/constants.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/widgets/buttons/play_button.dart';
import 'package:vocab_app/utils/formatter.dart';

class RecentWordTile extends StatelessWidget {
  final WordModel recentWord;
  const RecentWordTile({super.key, required this.recentWord});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 1.5),
      child: SizedBox(
        width: double.maxFinite,
        child: Card(
          color: COLOR_CONST.darkCardShadowColor,
          elevation: SizeConfig.defaultSize * .5,
          shape: RoundedRectangleBorder(
            // Set rounded borders
            borderRadius: BorderRadius.circular(3),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recentWord.audioUrl!.isNotEmpty)
                    PlayButton(
                        audioUrl: recentWord.audioUrl!, playMode: "audio"),
                  SizedBox(height: SizeConfig.defaultSize),
                  Text(TextFormatter.titleCase(recentWord.word!),
                      style: FONT_CONST.MEDIUM_DEFAULT_16),
                  SizedBox(height: SizeConfig.defaultSize),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.defaultPadding),
                    child: Text(recentWord.definition!,
                        style: FONT_CONST.MEDIUM_DEFAULT_16),
                  ),
                  SizedBox(height: SizeConfig.defaultSize),
                  Text("COLLECTION  :  ${recentWord.id!.toUpperCase()}",
                      style: FONT_CONST.MEDIUM_DEFAULT_16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
