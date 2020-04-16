import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth/src/app.dart';
import 'package:flutter_auth/src/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_auth/src/blocs/simple_bloc_delegate.dart';
import 'package:flutter_auth/src/repositories/authentication_repository.dart';
import 'package:flutter_auth/src/services/analytics.dart';
import 'package:flutter_auth/src/services/local_storage.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LocalStorageService localStorageService = await LocalStorageService.getInstance();
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final AnalyticsService analyticsService = AnalyticsService();

  if (isInDebugMode) {
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }

  runApp(
    DevicePreview(
      enabled: false, //isInDebugMode,
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<AuthenticationBloc>(
              create: (BuildContext _) {
                return AuthenticationBloc(
                  localStorageService: localStorageService,
                  authRepository: authRepository,
                  analyticsService: analyticsService,
                )..add(const AuthenticationEvent.appStarted());
              },
            ),
          ],
          child: App(authRepository: authRepository, analyticsService: analyticsService),
        );
      },
    ),
  );
}
