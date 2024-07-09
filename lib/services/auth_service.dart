import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todo_list/utils/constants.dart';

class AuthService {
  final String baseLoginUrl = Constants.baseLoginUrl;

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse(baseLoginUrl);
    final payload = {
      'data': {
        'db': {
          'email': email,
        },
        'password': password,
      },
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to login: ${response.statusCode} ${response.reasonPhrase}');
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
