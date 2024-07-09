// Library imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/components/bloc/auth_bloc.dart';
import 'package:todo_list/data/repositories/auth_provider.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';

// Local imports
import 'package:todo_list/utils/color_palette.dart';
import 'package:todo_list/components/bloc/bloc_state_observer.dart';
import 'package:todo_list/components/bloc/task_bloc.dart';
import 'package:todo_list/data/repositories/task_data_provider.dart';
import 'package:todo_list/data/repositories/task_repository.dart';
import 'package:todo_list/routes/app_router.dart';
import 'package:todo_list/routes/screens.dart';
import 'package:todo_list/views/home.dart';
import 'package:todo_list/views/login.dart';

// Bypassing SSL certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocStateObserver();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(
    preferences: preferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(
        authProvider: AuthProvider(preferences: preferences),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              AuthRepository(
                authProvider: AuthProvider(preferences: preferences)
              )
            ),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              TaskRepository(
                taskDataProvider: TaskDataProvider(preferences),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Todo List',
          theme: ThemeData(
            fontFamily: 'Sora',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
            useMaterial3: true,
          ),
          initialRoute: Screens.login,
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
  }
}
