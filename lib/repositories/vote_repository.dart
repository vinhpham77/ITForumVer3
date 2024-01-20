import 'package:dio/dio.dart';
import "package:it_forum/api_config.dart";
import 'package:it_forum/dtos/vote_dto.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';

class VoteRepository {
  late Dio dio;

  VoteRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.userServiceBaseUrl}/${ApiConfig.votesEndpoint}"));
  }

  // Future<Response<dynamic>> delete(int id) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> getId(int postId) async {
    return dio.get('', queryParameters: {'postId': postId});
  }

  Future<Response<dynamic>> checkVote(int targetId, bool targetType) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/checkVote?targetId=$targetId&targetType=$targetType');
  }

  Future<Response<dynamic>> createVote(VoteDTO voteDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/createVote', data: voteDTO.toJson());
  }

  Future<Response<dynamic>> updateVote(int id, VoteDTO voteDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/updateVote/$id', data: voteDTO.toJson());
  }

  Future<Response<dynamic>> deleteVote(int targetId, bool targetType) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/unVote?targetId=$targetId&targetType=$targetType');
  }
}
