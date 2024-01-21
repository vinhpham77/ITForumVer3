// ignore_for_file: unused_import
import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import 'package:it_forum/models/bookmarkInfo.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';

class BookmarkRepository {
  late Dio dio;

  BookmarkRepository() {
    dio = Dio(BaseOptions(
        baseUrl:
            "${ApiConfig.interactiveServiceBaseUrl}/${ApiConfig.bookmarksEndpoint}"));
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> addBookmark(BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/bookmark', data: bookmarkInfo.toJson());
  }

  Future<Response<dynamic>> unBookmark(BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/unBookmark', data: bookmarkInfo.toJson());
  }

  Future<Response<dynamic>> checkBookmark(BookmarkInfo bookmarkInfo) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/isBookmark', data: bookmarkInfo.toJson());
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
