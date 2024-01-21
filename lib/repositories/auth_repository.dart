import 'dart:async';

import 'package:dio/dio.dart';
import 'package:it_forum/api_config.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';

class AuthRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.userServiceBaseUrl}/${ApiConfig.authEndpoint}";

  AuthRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Response<dynamic>> loginUser(String username, String password) async {
    return dio.post("/signin", data: {
      'username': username,
      'password': password,
    });
  }

  Future<Response<dynamic>> registerUser(String username, String password,
      String email, String displayname) async {
    return dio.post(
      "/signup",
      data: {
        'username': username,
        'password': password,
        'email': email,
        'displayName': displayname
      },
    );
  }

  Future<Response<dynamic>> changePassUser(
      String username, String currentpassword, String newPassword) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post(
      "/changePassword",
      data: {
        'username': username,
        'currentPassword': currentpassword,
        'newPassword': newPassword
      },
    );
  }

  Future<Response<dynamic>> forgotPassUser(String username) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post(
      "/forgetPassword",
      data: {'username': username},
    );
  }

  Future<Response<dynamic>> resetPassUser(
      String username, String newPassword, String otp) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post(
      "/resetPassword",
      data: {'username': username, 'newPassword': newPassword, 'otp': otp},
    );
  }

  Future<Response<dynamic>> verify() async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.get("/verify");
  }
  Future<Response<dynamic>> logoutUser(String refreshToken) async {
    dio = JwtInterceptor().addInterceptors(dio);
    if (refreshToken == null) {
      throw Exception('Đăng xuất thất bại');
    }
    return dio.post("/logout",queryParameters: {
      'refreshToken': refreshToken,
    });
  }

}
