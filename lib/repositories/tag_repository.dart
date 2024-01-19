import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import "package:it_forum/models/tag.dart";

class TagRepository {
  late Dio dio;

  TagRepository() {
    dio = Dio(
        BaseOptions(baseUrl: "${ApiConfig.contentServiceBaseUrl}/${ApiConfig.tagsEndpoint}"));
  }

  Future<void> add(Tag tag) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get({int? page, int? size}) async {
    var optionalParams = page == null ? '' : '&page=$page';
    optionalParams += size == null ? '' : '&size=$size';

    return dio.get('?$optionalParams');
  }

  Future<Tag?> getOne(String name) async {
    throw UnimplementedError();
  }

  Future<void> update(Tag tag) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
