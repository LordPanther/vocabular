import 'package:flutter/cupertino.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/utils/translate.dart';

class DailyWordWidget extends StatefulWidget {
  final WordModel wordMap;

  const DailyWordWidget({
    super.key,
    required this.wordMap,
  });

  @override
  State<DailyWordWidget> createState() => _DailyWordWidgetState();
}

class _DailyWordWidgetState extends State<DailyWordWidget> {
  WordModel get wordMap => widget.wordMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildWordAudio(),
              SizedBox(
                width: SizeConfig.defaultSize * 1.5,
              ),
              _buildWord(),
            ],
          ),
          const SizedBox(height: 5),
          _buildPartOfSpeech(),
          const SizedBox(height: 3),
          _buildDefinition(),
          const SizedBox(height: 3),
        ],
      ),
    );
  }

  _buildWordAudio() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: COLOR_CONST.primaryColor.withOpacity(0.3)),
        child: const Icon(
          CupertinoIcons.speaker_3_fill,
          color: COLOR_CONST.backgroundColor,
        ),
      ),
    );
  }

  _buildWord() {
    return Text(
      wordMap.word!,
      style: FONT_CONST.MEDIUM_DEFAULT_20,
      maxLines: 2,
    );
  }

  _buildPartOfSpeech() {
    return Text(
      wordMap.definition!,
      style: FONT_CONST.REGULAR_DEFAULT_16,
      maxLines: 2,
    );
  }

  _buildDefinition() {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.5),
      child: Row(
        children: [
          Text(
            Translate.of(context).translate("definition"),
            style: FONT_CONST.MEDIUM_DEFAULT_16,
          ),
          Text(
            wordMap.definition!,
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
        ],
      ),
    );
  }
}
