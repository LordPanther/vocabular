// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocab_app/presentation/common_blocs/settings/app_settings_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/settings/app_settings_state.dart';
import 'package:vocab_app/presentation/common_blocs/application/application_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/application/application_event.dart';
import 'package:vocab_app/presentation/common_blocs/application/application_state.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/auth/auth_state.dart';
import 'package:vocab_app/presentation/common_blocs/common_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/profile/profile_event.dart';
import 'package:vocab_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'configs/application.dart';
import 'configs/language.dart';
import 'configs/router.dart';
import 'configs/theme.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    CommonBloc.applicationBloc.add(SetupApplicationEvent());
    super.initState();
    // _confirgureAmplify();
  }

  @override
  void dispose() {
    CommonBloc.dispose();
    super.dispose();
  }

  void onNavigate(String route) {
    _navigator!.pushNamedAndRemoveUntil(route, (route) => false);
  }

  void loadData(String userType) {
    userType == "user"
        ? BlocProvider.of<ProfileBloc>(context).add(LoadProfile("user"))
        : BlocProvider.of<ProfileBloc>(context).add(LoadProfile("guest"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, applicationState) {
        return BlocBuilder<AppSettingsBloc, AppSettingsState>(
          builder: (context, appSettingsState) {
            return MaterialApp(
              navigatorKey: _navigatorKey,
              debugShowCheckedModeBanner: Application.debug,
              title: Application.title,
              theme: AppTheme.defaultTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: AppRouter.SPLASH,
              locale: AppLanguage.defaultLanguage,
              supportedLocales: AppLanguage.supportLanguage,
              localizationsDelegates: const [
                Translate.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                return BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, authState) {
                    if (applicationState is ApplicationCompleted) {
                      if (authState is Unauthenticated) {
                        onNavigate(AppRouter.LOGIN);
                      } else if (authState is Uninitialized) {
                        onNavigate(AppRouter.SPLASH);
                      } else if (authState is Authenticated) {
                        authState.loggedFirebaseUser.isAnonymous
                            ? loadData("guest")
                            : loadData("user");
                        onNavigate(AppRouter.HOME);
                      }
                    } else {
                      onNavigate(AppRouter.SPLASH);
                    }
                  },
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
