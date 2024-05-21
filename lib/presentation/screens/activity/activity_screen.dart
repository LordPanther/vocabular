import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/image_constant.dart';
import 'package:vocab_app/presentation/screens/activity/bloc/activity_bloc.dart';
import 'package:vocab_app/presentation/screens/activity/bloc/activity_event.dart';
import 'package:vocab_app/presentation/screens/activity/widgets/activity_body.dart';
import 'package:vocab_app/presentation/screens/activity/widgets/activity_header.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivitiesBloc()..add(LoadActivities()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        IMAGE_CONST.BACKGROUND_ONE,
                      ),
                      fit: BoxFit.cover),
                ),
                child: const SafeArea(
                  child: Column(
                    children: [
                      ActivityHeader(),
                      ActivityBody(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
