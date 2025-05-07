import 'package:my_project/data/api/api_config.dart';
import 'package:my_project/domain/entities/user.dart';
import 'package:my_project/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await ApiConfig.get(ApiConfig.usersEndpoint);
      
      if (response is List) {
        return response.map((item) => User.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<User> getUserById(int id) async {
    try {
      final response = await ApiConfig.get('${ApiConfig.usersEndpoint}/$id');
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user with id $id: $e');
    }
  }

  @override
  Future<User> addUser(User user) async {
    try {
      final response = await ApiConfig.post(
        ApiConfig.usersEndpoint,
        user.toJson(),
      );
      
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  @override
  Future<User> updateUser(int id, User user) async {
    try {
      final endpoint = '${ApiConfig.usersEndpoint}/$id';
      final response = await ApiConfig.put(
        endpoint,
        user.toJson(),
      );
      
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user with id $id: $e');
    }
  }

  @override
  Future<bool> deleteUser(int id) async {
    try {
      final endpoint = '${ApiConfig.usersEndpoint}/$id';
      await ApiConfig.delete(endpoint);
      return true;
    } catch (e) {
      throw Exception('Failed to delete user with id $id: $e');
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await ApiConfig.post(
        ApiConfig.loginEndpoint,
        {
          'username': username,
          'password': password,
        },
      );
      
      return response['token'];
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}