import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";

class TagRepository {
  late Dio dio;

  TagRepository() {
    dio = Dio(BaseOptions(
        baseUrl:
            "${ApiConfig.contentServiceBaseUrl}/${ApiConfig.tagsEndpoint}"));
  }

  Future<Response<dynamic>> get({int? page, int? size}) async {
    var optionalParams = page == null ? '' : '&page=$page';
    optionalParams += size == null ? '' : '&size=$size';

    return dio.get('?$optionalParams');
  }

  Future<Response<dynamic>> getTagCounts(String username) async {
    return dio.get("/$username/counts");
  }
}
