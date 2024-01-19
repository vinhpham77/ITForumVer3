import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import 'package:it_forum/dtos/limit_page.dart';

import '../ui/common/utils/jwt_interceptor.dart';

class PostAggregationRepository {
  late Dio dio;

  PostAggregationRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.userServiceBaseUrl}/${ApiConfig.postsEndpoint}"));
  }

  Future<Response<dynamic>> getSearch({
    required String fieldSearch,
    required String searchContent,
    required String sort,
    required String sortField,
    required String page,
    int? limit
  }) async {
    return dio.get('/search?searchField=$fieldSearch&search=$searchContent&sort=$sort&sortField=$sortField&page=$page&limit=${limit ?? limitPage}');
  }

  Future<Response<dynamic>> get({
    required int page,
    int? limit,
    String tag = ""
  }) async {
    return dio.get('/get?page=${page}&limit=${limit ?? limitPage}&tag=${tag}');
  }

  Future<Response<dynamic>> getFollow({
    required int page,
    int? limit,
    bool isQuestion = false
  }) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/get/follow?page=${page}&limit=${limit}&isQuestion=${isQuestion}');
  }
}