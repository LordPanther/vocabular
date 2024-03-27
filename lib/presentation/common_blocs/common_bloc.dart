import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/screens/collections_manager/collections/bloc.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_bloc.dart';

import '../screens/verify_user/verify/verify_bloc.dart';
import 'application/application_bloc.dart';
import 'auth/auth_bloc.dart';
import 'language/language_bloc.dart';

class CommonBloc {
  /// Bloc
  static final applicationBloc = ApplicationBloc();
  static final authencationBloc = AuthenticationBloc();
  static final verificationBloc = VerificationBloc();
  static final languageBloc = LanguageBloc();
  static final profileBloc = ProfileBloc();

  static final List<BlocProvider> blocProviders = [
    BlocProvider<ApplicationBloc>(
      create: (context) => applicationBloc,
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => authencationBloc,
    ),
    BlocProvider<VerificationBloc>(
      create: (context) => verificationBloc,
    ),
    BlocProvider<LanguageBloc>(
      create: (context) => languageBloc,
    ),
    BlocProvider<ProfileBloc>(
      create: (context) => profileBloc,
    ),
  ];

  /// Dispose
  static void dispose() {
    applicationBloc.close();
    authencationBloc.close();
    verificationBloc.close();
    profileBloc.close();
    languageBloc.close();
  }

  /// Singleton factory
  static final CommonBloc _instance = CommonBloc._internal();

  factory CommonBloc() {
    return _instance;
  }
  CommonBloc._internal();
}
