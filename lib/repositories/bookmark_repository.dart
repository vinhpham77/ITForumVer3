// ignore_for_file: unused_import
import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import 'package:it_forum/models/bookmarkInfo.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';

class BookmarkRepository {
  late Dio dio;

  BookmarkRepository() {
    dio = Dio(BaseOptions(

        baseUrl: "${ApiConfig.interactiveServiceBaseUrl}/${ApiConfig.bookmarksEndpoint}"));
  }

  // Future<Response<dynamic>> delete(int id) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> addBookmark(
      String username, BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/bookmark/$username', data: bookmarkInfo.toJson());
  }

  Future<Response<dynamic>> unBookmark(
      String username, BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/unBookmark?username=$username', data: bookmarkInfo.toJson());
  }

  Future<Response<dynamic>> checkBookmark(
      String username, BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/isBookmark?username=$username', data: bookmarkInfo.toJson());
  }

  Future<Response<dynamic>> getBookmarkByUsername(String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/byUsername?username=$username');
  }

  Future<Response<dynamic>> getPostByUserName(
      {required String username,
      int? page,
      int? limit,
      String tag = ""}) async {
    var optionalParams = page == null ? '' : 'page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    optionalParams += '&tag=$tag';
    return dio.get('/getPost?username=$username&$optionalParams');
  }

  Future<Response<dynamic>> getSeriesByUserName(
      {required String username, int? page, int? limit}) async {
    var optionalParams = page == null ? '' : 'page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    return dio.get('/getSeries?username=$username&$optionalParams');
  }
}
