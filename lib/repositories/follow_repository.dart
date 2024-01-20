import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";

import '../ui/common/utils/jwt_interceptor.dart';

class FollowRepository {
  late Dio dio;

  FollowRepository() {
    dio = Dio(BaseOptions(
        baseUrl:
            "${ApiConfig.userServiceBaseUrl}/${ApiConfig.followsEndpoint}"));
  }

  Future<Response<dynamic>> add(String followed) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/follow', data: followed);
  }

  Future<Response<dynamic>> delete(String followed) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post(
      "/unfollow",
      data: followed,
    );
  }

  Future<Response<dynamic>> isFollowing(String followed) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/is-following/$followed');
  }

  Future<Response<dynamic>> follow(String followed) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/follow', data: followed);
  }

  Future<Response<dynamic>> unfollow(String followed) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/unfollow', data: followed);
  }

  Future<Response<dynamic>> checkfollow(String followed) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/is-following/$followed');
  }

  Future<Response<dynamic>> totalFollower(String followedId) async {
    return dio.get('/totalFollower/$followedId');
  }

  Future<Response<dynamic>> getFollowed() async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.get("/get/followed");
  }

  Future<Response<dynamic>> getStats(String username) async {
    return dio.get("/stats/$username");
  }
}
