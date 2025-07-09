import 'package:bloc/bloc.dart';
import '../repositories/auth_repository.dart';
import '../models/login_request_model.dart';
import '../view_models/auth_view_model.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthViewModel _authViewModel = AuthViewModel(AuthRepository());

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await _authViewModel.login(
          LoginRequest(email: event.email, password: event.password),
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _authViewModel.logout();
      emit(AuthInitial());
    });
  }
}
