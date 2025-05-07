abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class Login extends AuthEvent {
  final String username;
  final String password;
  
  Login({
    required this.username,
    required this.password,
  });
}

class Logout extends AuthEvent {}

class GetUserProfile extends AuthEvent {
  final int userId;
  
  GetUserProfile({required this.userId});
}