import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list/data/models/task_model.dart';
import 'package:todo_list/services/task_service.dart';
import 'package:todo_list/utils/exceptions_handler.dart';



class TaskDataProvider {
  SharedPreferences? prefs;
  TaskService taskService = TaskService();
  
  List<TaskModel> tasks = [];
  TaskDataProvider(this.prefs );

  Future<List<TaskModel>> getTasks() async {
    try {
      if (true) {
        var data = await taskService.fetchData();
        final List<dynamic> response = json.decode(data.body);
        tasks = response.map((task) => TaskModel.fromJson(task['db'])).toList();
        //Filter task with status_del = 1
        tasks = tasks.where((task) => task.statusDel == 1).toList();
        tasks.sort((a, b) {
          if (a.isDone == b.isDone) {
            return 0;
          } else if (a.isDone) {
            return 1;
          } else {
            return -1;
          }
        });
      }

      return tasks;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  Future<List<TaskModel>> sortTasks(int sortOption) async {
    switch (sortOption) {
      case 0:
        tasks.sort((a, b) {
          // Sort by date
          if (a.startDate!.isAfter(b.startDate!)) {
            return 1;
          } else if (a.startDate!.isBefore(b.startDate!)) {
            return -1;
          }
          return 0;
        });
        break;
      case 1:
        //sort by isDone tasks
        tasks.sort((a, b) {
          if (!a.isDone && b.isDone) {
            return 1;
          } else if (a.isDone && !b.isDone) {
            return -1;
          }
          return 0;
        });
        break;
      case 2:
        //sort by pending tasks
        tasks.sort((a, b) {
          if (a.isDone == b.isDone) {
            return 0;
          } else if (a.isDone) {
            return 1;
          } else {
            return -1;
          }
        });
        break;
    }
    return tasks;
  }

  Future<void> createTask(TaskModel taskModel) async {
    try {
      // tasks.add(taskModel);

      // await prefs!.setStringList(
      //   Constants.taskKey,
      //   tasks.map((task) => json.encode(task.toJson())).toList(),
      // );
      final response = await taskService.createTask(taskModel);
      getTasks();
      if (response.statusCode == 200) {
        print('Task created successfully');
        print('response: ${response.body}');
      } else {
        print('response: ${response.body}');

        throw Exception(
            'Failed to create task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    try {
      // tasks = tasks.map((task) {
      //   if (task.id == taskModel.id) {
      //     return taskModel;
      //   }
      //   return task;
      // }).toList();
      // await prefs!.setStringList(
      //   Constants.taskKey,
      //   tasks.map((task) => json.encode(task.toJson())).toList(),
      // );
      // return tasks;
      final response = await taskService.updateTask(taskModel);
      getTasks();
      if (response.statusCode == 200) {
        print('Task updated successfully');
        return tasks;
      } else {
        throw Exception(
            'Failed to update task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    try {
      final response = await taskService.deleteTask(taskModel);
      getTasks();
      if (response.statusCode == 200) {
        print('Task deleted successfully');
        return tasks;
      } else {
        throw Exception(
            'Failed to delete task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  Future<List<TaskModel>> searchTasks(String search) async {
    try {
      final List<TaskModel> searchResults = tasks
          .where((task) =>
              task.title.toLowerCase().contains(search.toLowerCase()) ||
              task.notes!.toLowerCase().contains(search.toLowerCase()))
          .toList();
      return searchResults;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }
}
