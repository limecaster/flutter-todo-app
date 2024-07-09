import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_login);
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      await authRepository.login(event.email, event.password);
      emit(LoginSuccess());
    } catch (exception) {
      emit(LoginFailure(error: exception.toString()));
    }
  }
}
