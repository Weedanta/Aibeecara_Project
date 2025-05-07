import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/user.dart';
import 'package:my_project/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<GetUserProfile>(_onGetUserProfile);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');

      if (token != null && userId != null) {
        try {
          final user = await _userRepository.getUserById(userId);
          emit(Authenticated(token: token, user: user));
        } catch (_) {
          // If we can't get the user profile, clear stored credentials
          await prefs.remove('token');
          await prefs.remove('userId');
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogin(
    Login event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      debugPrint('Attempting login with: ${event.username}');
      final token = await _userRepository.login(
        event.username,
        event.password,
      );
      debugPrint(
          'Login successful, token received: ${token.substring(0, 10)}...');

      const userId = 1;

      // Store credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('userId', userId);

      try {
        // Ambil profil pengguna
        final user = await _userRepository.getUserById(userId);
        emit(Authenticated(token: token, user: user));
      } catch (userError) {
        // Jika gagal mengambil user, tetap login dengan user dummy
        debugPrint('Error getting user: $userError');

        // Buat user dummy karena login berhasil
        final dummyUser = User(
          id: userId,
          username: event.username,
          email: 'dummy@example.com',
        );

        emit(Authenticated(token: token, user: dummyUser));
      }
    } catch (e) {
      debugPrint('Login error: $e');
      emit(AuthError(message: 'Invalid username or password: $e'));
    }
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Clear stored credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userId');

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (state is Authenticated) {
        final currentState = state as Authenticated;
        emit(AuthLoading());

        final user = await _userRepository.getUserById(event.userId);

        emit(Authenticated(
          token: currentState.token,
          user: user,
        ));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
