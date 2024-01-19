// ignore_for_file: unused_import

import "package:it_forum/api_config.dart";
import 'package:it_forum/dtos/sub_comment_dto.dart';
import 'package:dio/dio.dart';

import '../ui/common/utils/jwt_interceptor.dart';

class CommentRepository {
  late Dio dio;

  CommentRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.userServiceBaseUrl}/${ApiConfig.commentsEndpoint}"));
  }

  Future<Response<dynamic>> add(int postId, bool type, SubCommentDto subCommentDto) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/$postId/$type/add', data: subCommentDto.toJson());
  }

  Future<Response<dynamic>> getSubComment(int postId, bool type, int? subId) async {
    dio = JwtInterceptor().addInterceptors(dio);
    String param = subId == null ? "" : subId.toString();
    return dio.get('/$postId/$type/get?subId=$param');
  }

  Future<Response<dynamic>> deleteSubComment(int postId, bool type, int subId) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/$postId/$type/$subId/delete');
  }

  Future<Response<dynamic>> updateSubComment(
      int postId, bool type, int? subId, SubCommentDto subCommentDto) async {
    dio = JwtInterceptor().addInterceptors(dio);
    String param = subId == null ? "" : subId.toString();
    return dio.put('/$postId/$type/$param/update', data: subCommentDto.toJson());
  }
}
