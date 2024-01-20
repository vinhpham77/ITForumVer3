import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';

import '../../../../../dtos/post_user.dart';
import '../../../../../dtos/series_post.dart';
import '../../../../../dtos/series_post_user.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/series_repository.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../../repositories/follow_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final PostRepository _postRepository = PostRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();
  final UserRepository _userRepository = UserRepository();
  final FollowRepository _followRepository = FollowRepository();

  FollowBloc() : super(FollowInitialState()) {
    on<LoadPostsFollowEvent>(_loadPostsFollow);
    on<LoadSeriesFollowEvent>(_loadSeriesFollow);
  }

  Future<void> _loadPostsFollow(
      LoadPostsFollowEvent event, Emitter<FollowState> emit) async {
    try {
      var followResponse = await _followRepository.getFollowed();
      List<User> users = (followResponse.data as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList();
      List<String> usernames = users.map((e) => e.username).toList();
      Response<dynamic> response = await _postRepository.getInUsernames(
          username: usernames, page: event.page, limit: event.limit, tag: event.tag);

      ResultCount<Post> posts =
          ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        List<PostUser> postUsers = convertPostUser(posts.resultList, users);

        ResultCount<PostUser> postUserResults =
            ResultCount<PostUser>(count: posts.count, resultList: postUsers);

        emit(PostFollowLoadedState(postUsers: postUserResults));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  Future<void> _loadSeriesFollow(
      LoadSeriesFollowEvent event, Emitter<FollowState> emit) async {
    try {
      var followResponse = await _followRepository.getFollowed();
      List<User> users = (followResponse.data as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList();
      List<String> usernames = users.map((e) => e.username).toList();

      Response<dynamic> response = await _seriesRepository.getInUsernames(
        username: usernames,
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesPost> seriesPosts =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPosts.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {

        List<SeriesPostUser> seriesPostUsers =
        convertSeriesPostUser(seriesPosts.resultList, users);

        ResultCount<SeriesPostUser> seriesPostUserResults =
        ResultCount<SeriesPostUser>(
            count: seriesPosts.count, resultList: seriesPostUsers);

        emit(SeriesFollowLoadedState(seriesPostUsers: seriesPostUserResults));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
