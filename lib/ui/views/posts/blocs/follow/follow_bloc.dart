import 'package:it_forum/dtos/result_count.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_post.dart';
import '../../../../../models/post.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/series_repository.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final PostRepository _postRepository = PostRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();

  FollowBloc() : super(FollowInitialState()) {
    on<LoadPostsFollowEvent>(_loadPostsFollow);
    on<LoadSeriesFollowEvent>(_loadSeriesFollow);
  }

  Future<void> _loadPostsFollow(
      LoadPostsFollowEvent event, Emitter<FollowState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getFollow(
          page: event.page, limit: event.limit, tag: event.tag);

      ResultCount<Post> posts =
          ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(PostFollowLoadedState(posts: posts));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
  Future<void> _loadSeriesFollow(
      LoadSeriesFollowEvent event, Emitter<FollowState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getFollow(
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesPost> seriesPost =
      ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPost.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(SeriesFollowLoadedState(seriesPost: seriesPost));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
