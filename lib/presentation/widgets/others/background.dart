import 'package:flutter/material.dart';

import '../../../constants/image_constant.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(IMAGE_CONST.BACKGROUND), fit: BoxFit.cover)),
    );
  }
}
