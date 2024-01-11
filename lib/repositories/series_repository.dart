import "package:it_forum/api_config.dart";
import "package:it_forum/dtos/series_dto.dart";
import "package:it_forum/ui/common/utils/index.dart";
import 'package:dio/dio.dart';

import "../dtos/limit_page.dart";

class SeriesRepository {
  late Dio dio;

  SeriesRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.seriesEndpoint}"));
  }

  Future<Response<dynamic>> add(SeriesDTO seriesDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/create', data: seriesDTO.toJson());
  }

  Future<Response<dynamic>> delete(int id) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.delete('/$id/delete');
  }

  Future<Response<dynamic>> get({int? page, int? size}) async {
    var optionalParams = page == null ? '' : 'page=$page';
    optionalParams += size == null ? '' : '&size=$size';
    return dio.get('/get?$optionalParams');
  }

  Future<Response<dynamic>> getByUser(String username,
      {int? page, int? size}) async {
    dio = JwtInterceptor().addInterceptors(dio);

    return dio
        .get('/by/$username', queryParameters: {"page": page, "size": size});
  }

  Future<Response<dynamic>> getOne(int id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/$id');
  }

  Future<Response<dynamic>> update(int id, SeriesDTO seriesDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.put('/$id/update', data: seriesDTO.toJson());
  }

  Future<Response<dynamic>> updateScore(int idPost, int score) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio
        .put('/updateScore?id=$idPost&score=$score');
  }

  Future<Response<dynamic>> totalSeries(String username) async {
    return dio.get('/totalSeries/$username');
  }

  Future<Response<dynamic>> getFollow({
    required int page,
    int? limit,
  }) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/get/follow?page=${page}&limit=${limit}');
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
}
