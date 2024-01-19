
import 'package:dio/dio.dart';

import "package:it_forum/api_config.dart";

class SpRepository {
  late Dio dio;

  SpRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.userServiceBaseUrl}/${ApiConfig.seriesEndpoint}"));
  }
  Future<Response<dynamic>> getOne(int id) async {
    return dio.get('/detail/$id');
  }

}