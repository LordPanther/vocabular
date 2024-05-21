import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/configs/config.dart';
import 'package:vocab_app/data/models/activity_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/presentation/screens/activity/bloc/bloc.dart';
import 'package:vocab_app/presentation/widgets/others/loading.dart';
import 'package:vocab_app/presentation/widgets/single_card/activity_card.dart';
import 'package:vocab_app/utils/utils.dart';

class ActivityBody extends StatefulWidget {
  const ActivityBody({super.key});

  @override
  State<ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<ActivityBody> {
  late ActivitiesBloc _activitiesBloc;
  late List<WordModel> _words;

  @override
  void initState() {
    super.initState();
    _activitiesBloc = BlocProvider.of<ActivitiesBloc>(context);
  }

  void selectActivity(ActivityModel activity) {
    _activitiesBloc.add(LoadActivity(activity: activity));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivitiesBloc, ActivitiesState>(
      listener: (context, state) {
        if (state is ActivitiesLoading) {
          if (state.error!.isNotEmpty) {
            UtilDialog.showCustomContent(context,
                content: "This activity is not available yet, sorry.");
          }
        }
      },
      child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, state) {
          if (state is ActivitiesLoading) {
            var activities = state.activityResponse!.activities;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultPadding * 4),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: activities!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.defaultPadding * 2),
                              child: GestureDetector(
                                  onTap: () {
                                    var activity = activities[index];
                                    selectActivity(activity);
                                  },
                                  child: ActivityCard(
                                      key: ValueKey(activities[index].id),
                                      activity: activities[index])));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ActivitiesLoaded) {}
          return const Center(
            child: Loading(),
          );
        },
      ),
    );
  }
}
