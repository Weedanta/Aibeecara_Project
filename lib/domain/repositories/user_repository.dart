import 'package:my_project/domain/entities/user.dart';

abstract class UserRepository {
  /// Get all users
  Future<List<User>> getAllUsers();
  
  /// Get a single user by ID
  Future<User> getUserById(int id);
  
  /// Create a new user
  Future<User> addUser(User user);
  
  /// Update a user
  Future<User> updateUser(int id, User user);
  
  /// Delete a user
  Future<bool> deleteUser(int id);
  
  /// Login a user
  Future<String> login(String username, String password);
}