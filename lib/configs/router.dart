// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vocab_app/presentation/screens/collections/collection_screen.dart';
import 'package:vocab_app/presentation/screens/homep_page/widgets/home_page_form.dart';
// import 'package:vocab_app/presentation/screens/home_page/home_screen.dart';

// import '../bottom_navigation.dart';
import '../data/models/user_model.dart';
import '../presentation/screens/confirm_password_reset/confrim_password_reset.dart';
import '../presentation/screens/forgot_password/forgot_password_screen.dart';
import '../presentation/screens/initialize_info/initialize_info_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/new_password/new_password_screen.dart';
import '../presentation/screens/register/register_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/verify_user/verification_screen.dart';

class AppRouter {
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String INITIALIZE_INFO = '/initialize_info';
  static const String REGISTER = '/register';
  static const String VERIFY_USER = '/verify_user';
  static const String FORGOT_PASSWORD = '/forgot_password';
  static const String HOME = '/home';
  static const String CONFIRM_PASSWORD_RESET = '/confirm_password_reset';
  static const String NEW_PASSWORD = '/new_password';
  static const String COLLECTIONS = '/collections';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case FORGOT_PASSWORD:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case NEW_PASSWORD:
        return MaterialPageRoute(
          builder: (_) => const NewPasswordScreen(),
        );
      case CONFIRM_PASSWORD_RESET:
        var newPassword = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ConfirmPasswordResetScreen(newPassword: newPassword),
        );
      case LOGIN:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case REGISTER:
        var selection = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            selection: selection,
          ),
        );
      case HOME:
        return MaterialPageRoute(
          // builder: (_) => const HomeScreen(),
          builder: (_) => const HomePageForm(),
        );
      case INITIALIZE_INFO:
        return MaterialPageRoute(
          builder: (_) => const InitializeInfoScreen(),
        );
      case VERIFY_USER:
        return MaterialPageRoute(
          builder: (_) => const VerificationScreen(),
        );
      case COLLECTIONS:
        return MaterialPageRoute(builder: (_) => const CollectionScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  ///Singleton factory
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal();
}
