import 'package:flutter/material.dart';
import 'package:vocab_app/constants/color_constant.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(COLOR_CONST.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
