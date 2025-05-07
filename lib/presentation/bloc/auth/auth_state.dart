import 'package:my_project/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final User user;
  
  Authenticated({
    required this.token,
    required this.user,
  });
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  AuthError({required this.message});
}