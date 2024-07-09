import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:todo_list/utils/constants.dart';
import 'package:todo_list/data/models/task_model.dart';

class TaskService {
  final String _baseUrl = Constants.baseHttpUrl;

  Future<String> _getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token') == null) ? Constants.tokenKey : prefs.getString('token')!;
    return token;
  }

  Future<http.Response> fetchData() async {
    final String token = await _getBearerToken();
    //final url = Uri.parse('$_baseUrl/gets');
    final url = Uri.parse('$_baseUrl/gets');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      print('Error: $e'); // Log the error for more context
      throw Exception(
          'An unexpected error occurred: ${e.toString()}'); // Throw a more descriptive error
    }
  }

  Future<http.Response> createTask(TaskModel task) async {
    String token = await _getBearerToken();
    final url = Uri.parse('$_baseUrl/create');

    final payload = {
      'data': {
        'db': {
          'id': task.id,
          'title': task.title,
          'notes': task.notes,
          'priority': task.priority ?? 1,
          'is_important': task.isImportance,
          'is_starred': task.isStarred,
          'is_done': task.isDone,
          'start_date': task.startDate.toString(),
          'due_date': task.dueDate.toString(),
          'tags': [],
          'status_del': 1,
          'is_system': false
        },
        'ten_nguoi_cap_nhat': 'admin'
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to create task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception(
          'An unexpected error occurred: ${e.toString()}'); // Throw a more descriptive error
    }
  }

  Future<http.Response> updateTask(TaskModel task) async {
    String token = await _getBearerToken();
    final url = Uri.parse('$_baseUrl/edit');

    final payload = {
      'data': {
        'db': {
          'id': task.id,
          'title': task.title,
          'notes': task.notes,
          'priority': task.priority ?? 1,
          'is_important': task.isImportance,
          'is_starred': task.isStarred,
          'is_done': task.isDone,
          'start_date': task.startDate.toString(),
          'due_date': task.dueDate.toString(),
          'tags': [],
          'status_del': 1,
          'is_system': false
        },
        'ten_nguoi_cap_nhat': 'admin'
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to update task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      print('Error: $e'); // Log the error for more context
      throw Exception(
          'An unexpected error occurred: ${e.toString()}'); // Throw a more descriptive error
    }
  }

  Future<http.Response> deleteTask(TaskModel task) async {
    String token = await _getBearerToken();
    final url = Uri.parse('$_baseUrl/update_status_del');

    final payload = {
      'id': task.id,
      'status_del': 0,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to delete task: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      print('Error: $e'); // Log the error for more context
      throw Exception(
          'An unexpected error occurred: ${e.toString()}'); // Throw a more descriptive error
    }
  }
}