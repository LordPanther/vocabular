import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/presentation/screens/verify_user/verify/verify_bloc.dart';
import 'package:vocab_app/presentation/screens/verify_user/widgets/verification_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/verification_body.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const Scaffold(
          backgroundColor: COLOR_CONST.backgroundColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerificationHeader(),
                VerificationBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
