import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";

class ContentRepository {
  late Dio dio;

  ContentRepository() {
    dio = Dio(
        BaseOptions(baseUrl: "${ApiConfig.contentServiceBaseUrl}/${ApiConfig.contentEndpoint}"));
  }

  Future<Response<dynamic>> getStats(String username) async {
    return dio.get("/$username/stats");
  }
}
