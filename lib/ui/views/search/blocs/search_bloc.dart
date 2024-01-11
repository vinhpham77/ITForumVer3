
import 'package:it_forum/dtos/result_count.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_post.dart';
import '../../../../../models/post.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/series_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostRepository _postRepository = PostRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();

  SearchBloc() : super(FollowInitialState()) {
    on<LoadPostsEvent>(_loadPostsSearch);
    on<LoadSeriesEvent>(_loadSeriesSearch);
  }

  Future<void> _loadPostsSearch(
      LoadPostsEvent event, Emitter<SearchState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getSearch(
          fieldSearch: event.fieldSearch, searchContent: event.searchContent,
          sort: event.sort, sortField: event.sortField, page: event.page, limit: event.limit);

      ResultCount<Post> posts = ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(PostLoadedState(posts: posts));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
  Future<void> _loadSeriesSearch(
      LoadSeriesEvent event, Emitter<SearchState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getSearch(
          fieldSearch: event.fieldSearch, searchContent: event.searchContent,
          sort: event.sort, sortField: event.sortField, page: event.page, limit: event.limit);

      ResultCount<SeriesPost> seriesPost =
      ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPost.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(SeriesLoadedState(seriesPost: seriesPost));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}