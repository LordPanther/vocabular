import 'package:flutter/material.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/constants/font_constant.dart';

class WordTile extends StatelessWidget {
  final String word;
  final String definition;

  const WordTile({
    required this.word,
    required this.definition,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize),
      child: ListTile(
        title: _buildWord(),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _buildDefinition(),
            // const SizedBox(height: 3),
            // _buildSynonym()
          ],
        ),
        onTap: () {
          /// OnLongpress popup to delete word
        },
      ),
    );
  }

  _buildWord() {
    return Text(
      word,
      style: FONT_CONST.MEDIUM_DEFAULT_20,
      maxLines: 2,
    );
  }

  _buildDefinition() {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.5),
      child: Row(
        children: [
          Text(
            "definition: ",
            style: FONT_CONST.MEDIUM_DEFAULT_16,
          ),
          Text(
            definition,
            style: FONT_CONST.REGULAR_DEFAULT_16,
          ),
        ],
      ),
    );
  }

  // _buildSynonym() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.5),
  //     child: Row(
  //       children: [
  //         Text(
  //           "synonym: ",
  //           style: FONT_CONST.MEDIUM_DEFAULT_16,
  //         ),
  //         Text(
  //           synonyms,
  //           style: FONT_CONST.REGULAR_DEFAULT_16,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
