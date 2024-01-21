
import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";

import '../ui/common/utils/jwt_interceptor.dart';

class SpRepository {
  late Dio dio;

  SpRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.contentServiceBaseUrl}/${ApiConfig.seriesEndpoint}"));
  }
  Future<Response<dynamic>> getOne(int id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/detail/$id');
  }

}