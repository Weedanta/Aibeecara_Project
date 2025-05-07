import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String baseUrl = 'https://fakestoreapi.com';

  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  static const String cartsEndpoint = '/carts';
  static const String usersEndpoint = '/users';
  static const String loginEndpoint = '/auth/login';

  static final http.Client _client = http.Client();

  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> getHeaders({String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .get(url, headers: getHeaders(token: token))
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error during GET request to $endpoint: $e');
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, dynamic data, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .post(
            url,
            headers: getHeaders(token: token),
            body: json.encode(data),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error during POST request to $endpoint: $e');
      rethrow;
    }
  }

  static Future<dynamic> put(String endpoint, dynamic data, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .put(
            url,
            headers: getHeaders(token: token),
            body: json.encode(data),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error during PUT request to $endpoint: $e');
      rethrow;
    }
  }

  static Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .delete(url, headers: getHeaders(token: token))
          .timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error during DELETE request to $endpoint: $e');
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  
  ApiException({
    required this.statusCode,
    required this.message,
  });
  
  @override
  String toString() {
    return 'ApiException: [$statusCode] $message';
  }
}