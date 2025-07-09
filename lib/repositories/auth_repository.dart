import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://ezyappteam.ezycourse.com/api/app/'));

  Future<String> login(String email, String password) async {
    final response = await _dio.post('/student/auth/login', data: {
      'email': email.trim(),
      'password': password.trim(),
    });
    return response.data['token'];
  }

  Future<void> logout(String token) async {
    await _dio.post(
      '/student/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}