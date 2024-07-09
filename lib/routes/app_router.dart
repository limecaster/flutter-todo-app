// Library imports
import 'package:flutter/material.dart';

// Local imports
import 'package:todo_list/views/screen_not_found.dart';
import 'package:todo_list/views/splash_screen.dart';
import 'package:todo_list/views/login.dart';
import 'package:todo_list/views/home.dart';
import 'package:todo_list/views/add_task.dart';
import 'package:todo_list/views/update_task.dart';
import 'package:todo_list/routes/screens.dart';
import 'package:todo_list/data/models/task_model.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Screens.splashScreen:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case Screens.login:
      return MaterialPageRoute(
        builder: (context) => const Login(),
      );
    case Screens.home:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case Screens.addTask:
      return MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      );
    case Screens.updateTask:
      final args = routeSettings.arguments as TaskModel;
      return MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(taskModel: args),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const ScreenNotFound(),
      );
  }
}