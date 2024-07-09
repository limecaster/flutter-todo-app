import 'package:todo_list/data/repositories/auth_provider.dart';

class AuthRepository {
  final AuthProvider authProvider;
  
  AuthRepository({required this.authProvider});

  Future<void> login(String email, String password) async {
    return await authProvider.login(email, password);
  }
}