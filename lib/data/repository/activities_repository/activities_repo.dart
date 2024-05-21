import 'package:vocab_app/data/models/activity_model.dart';

abstract class ActivitiesRepository {
  Future<List<ActivityModel>> getActivityData();
}
