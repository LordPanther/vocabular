// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vocab_app/data/models/activity_model.dart';
// import 'package:vocab_app/data/repository/activities_repository/activity_repo.dart';

// class FirebaseActivitiesRepository implements ActivityRepository {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final _userHome = FirebaseFirestore.instance;
//   User? get user => _firebaseAuth.currentUser;

//   /// [FirebaseAuthRepository]
//   /// Called once on registration to create collections:[defaultcollections]

//   @override
//   Future<ActivityModel> getActivityData() async {
//     var snapshot =
//         await _userHome.collection("activities").doc("swipecards").get();
//     Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

//     var activity = ActivityModel(
//       id: data["id"],
//       players: List<String>.from(data["players"]),
//       rating: data["rating"],
//       playCount: data["playcount"],
//     );

//     print(
//         'Activity ID: ${activity.id}, Players: ${activity.players}, Rating: ${activity.rating}, Play Count: ${activity.playCount}');

//     return activity;
//   }
// }
