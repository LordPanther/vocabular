import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

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
  AudioPlayer audioPlayer = AudioPlayer();
  WordModel get wordMap => widget.wordMap;

  Future<void> _playAudio() async {
    if (await Permission.audio.isGranted) {
      await audioPlayer.setSourceUrl(wordMap.audio);
    } else {
      await Permission.audio.request();
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
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
            _buildPhonetic(),
            const SizedBox(height: 5),
            _buildPartOfSpeech(),
            const SizedBox(height: 3),
            _buildTenses(),
            const SizedBox(height: 3),
            _buildMeaning(),
            const SizedBox(height: 3),
            _buildExample(),
          ],
        ),
      ),
    );
  }

  _buildWordAudio() {
    return GestureDetector(
      onTap: _playAudio,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: COLOR_CONST.primaryColor),
        child: const Icon(
          CupertinoIcons.speaker_3_fill,
          color: COLOR_CONST.backgroundColor,
        ),
      ),
    );
  }

  _buildWord() {
    return Text(
      wordMap.word,
      style: FONT_CONST.MEDIUM_DEFAULT_20,
      maxLines: 2,
    );
  }

  _buildPhonetic() {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 5.5),
      child: Text(
        wordMap.phonetic,
        style: FONT_CONST.REGULAR_DEFAULT_16,
      ),
    );
  }

  _buildPartOfSpeech() {
    return Text(
      wordMap.partOfSpeech,
      style: FONT_CONST.REGULAR_DEFAULT_16,
      maxLines: 2,
    );
  }

  _buildTenses() {
    return Text(
      "verb:         ;present tense:         ;past tense:         ",
      style: FONT_CONST.BOLD_DEFAULT_16,
    );
  }

  _buildMeaning() {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.5),
      child: Row(
        children: [
          Text(
            "meaning: ",
            style: FONT_CONST.MEDIUM_DEFAULT_16,
          ),
          Text(
            wordMap.meaning,
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
        ],
      ),
    );
  }

  _buildExample() {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.5),
      child: Row(
        children: [
          Text(
            "example: ",
            style: FONT_CONST.MEDIUM_DEFAULT_16,
          ),
          Text(
            wordMap.example,
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
        ],
      ),
    );
  }
}
