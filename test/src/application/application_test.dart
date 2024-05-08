// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vocab_app/configs/application.dart';
// import 'package:vocab_app/data/local/pref.dart';
// import 'package:vocab_app/presentation/common_blocs/application/bloc.dart';
// import 'package:vocab_app/presentation/common_blocs/common_bloc.dart';

// class MockLocalPref extends Mock implements LocalPref {}

// class MockApplication extends Mock implements Application {}

// class MockSharedPreferences extends Mock implements SharedPreferences {}



// void main() {

//   late Application application;

//   setUp(() {
//     application = MockApplication();
//   });

//   //APPLICATION test group
//   test(() async {

//   });



//   // group('ApplicationBloc', () {
//   //   final mockApplication = MockApplication();
//   //   var called = false;

//   //   when(() => LocalPref.getString("language")).thenAnswer((_) {
//   //     called = true;
//   //     return "en";
//   //   });

//   //   blocTest<ApplicationBloc, ApplicationState>(
//   //     "handles application initialization",
//   //     build: () => ApplicationBloc(),
//   //     act: (bloc) => bloc.add(SetupApplicationEvent()),
//   //     expect: () => <ApplicationState>[ApplicationCompleted()],
//   //     verify: (bloc) {
//   //       expect(called, true);
//   //       // expect(actual, matcher)
//   //     },
//   //   );
//   // });
// }
