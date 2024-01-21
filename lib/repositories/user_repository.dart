import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:it_forum/api_config.dart';

import '../dtos/user_dto.dart';
import '../ui/common/utils/jwt_interceptor.dart';

class UserRepository {
  late Dio dio;
  final String baseUrl =
      "${ApiConfig.userServiceBaseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Response<dynamic>> get(String username) async {
    return dio.get("/$username");
  }

  Future<Response<dynamic>> getFollows({
    required String username,
    required int page,
    required int size,
    required bool isFollowed,
  }) async {
    String object = isFollowed ? "followers" : "followings";
    return dio.get("/$username/$object", queryParameters: {
      "page": page,
      "size": size,
    });
  }

  Future<Response<dynamic>> getUsers(List<String> usernames) {
    return dio.post("/list", data: jsonEncode(usernames));
  }

  Future<Response<dynamic>> update(String username, UserDTO userDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.put('/$username', data: userDTO.toJson());
  }
  Future<Response<dynamic>> changePassUser(
      String username, String currentPassword, String newPassword) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post(
      "/changePassword",
      data: {
        'username': username,
        'currentPassword': currentPassword,
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

}
