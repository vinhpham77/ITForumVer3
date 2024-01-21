import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import "package:it_forum/dtos/post_dto.dart";
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';

import '../dtos/limit_page.dart';

class PostRepository {
  late Dio dio;

  PostRepository() {
    dio = Dio(BaseOptions(
        baseUrl:
            "${ApiConfig.contentServiceBaseUrl}/${ApiConfig.postsEndpoint}"));
  }

  get notificationRepository => null;

  Future<Response<dynamic>> add(PostDTO postDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);

    return dio.post('/create', data: postDTO.toJson());
  }

  Future<Response<dynamic>> delete(int id) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.delete('/$id/delete');
  }

  Future<Response<dynamic>> get(
      {required int page, int? limit, String tag = ""}) async {
    return dio.get('/get?page=$page&limit=${limit ?? limitPage}&tag=$tag');
  }

  Future<Response<dynamic>> getFollow(
      {required int page, int? limit, String tag = ""}) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/get/follow?page=$page&limit=$limit&tag=$tag');
  }

  Future<Response<dynamic>> getByUser(String username,
      {String? tag, int? page, int? size}) async {
    dio = JwtInterceptor().addInterceptors(dio);

    return dio.get("/by/$username",
        queryParameters: {"page": page, "size": size, "tag": tag});
  }

  Future<Response<dynamic>> getOne(int id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/$id');
  }

  Future<Response<dynamic>> getNumber() async {
    return dio.get('/number');
  }

  Future<Response<dynamic>> update(int id, PostDTO postDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.put('/$id/update', data: postDTO.toJson());
  }

  Future<Response<dynamic>> getOneDetails(int id) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.get('/$id/detail');
  }

  Future<Response<dynamic>> getPostsSameAuthor(
      String authorName, int postId) async {
    return dio.get('/postsSameAuthor/$authorName?postId=$postId');
  }

  Future<Response<dynamic>> updateScore(int idPost, int score) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/updateScore?id=$idPost&score=$score');
  }

  Future<Response<dynamic>> totalPost(String username) async {
    // dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/totalPost/$username');
  }

  Future<Response<dynamic>> getSearch(
      {required String fieldSearch,
      required String searchContent,
      required String sort,
      required String sortField,
      required String page,
      int? limit}) async {
    return dio.get(
        '/search?searchField=$fieldSearch&search=$searchContent&sort=$sort&sortField=$sortField&page=$page&limit=${limit ?? limitPage}');
  }

  Future<Response<dynamic>> getInUsernames(
      {required List<String> usernames, required int page, int? limit, String tag = ""}) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.get('/get/in_usernames?usernames=$usernames&page=$page&limit=$limit&tag=$tag');
  }
}
