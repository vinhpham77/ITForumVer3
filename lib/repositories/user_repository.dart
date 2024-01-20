import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:it_forum/api_config.dart';

class UserRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.userServiceBaseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Response<dynamic>> getUser(String username) async {
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
}
