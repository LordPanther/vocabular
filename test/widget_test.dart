
// import 'package:vocab_app/configs/application.dart';
// import 'package:vocab_app/presentation/common_blocs/application/application_bloc.dart';
// import 'package:vocab_app/presentation/common_blocs/application/application_event.dart';
// import 'package:vocab_app/presentation/common_blocs/application/application_state.dart';

// class MockApplicationBloc extends MockBloc<ApplicationEvent, ApplicationState> implements ApplicationBloc {

// void main() {
//   late ApplicationBloc applicationBloc;
//   late MockApplicationBloc mockApplication;

//   blocTest

//   setUp(() {
//     mockApplication = MockApplication();
//     applicationBloc = ApplicationBloc();
//   });

//   tearDown(() {});

//   test("initial values are correct", () {
//     expect(applicationBloc.isClosed, false);
//   });

//   group(
//     "_mapEventToState",
//     () {
//       blocTest(
//         "initializes language and authentication sequence",
//         () async {
//           await applicationBloc.mapEventToState();
//           // await applicationBloc.mapEventToState(emit);
//         },
//       );
//     },
//   );
// }
