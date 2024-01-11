import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/bookmark_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_post.dart';
import '../../../../../models/post.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();

  BookmarkBloc() : super(BookmarkInitialState()) {
    on<LoadBookmarkPostEvent>(_loadBookmarkPosts);
    on<LoadBookmarkSeriesEvent>(_loadBookmarkSeries);
  }

  Future<void> _loadBookmarkPosts(
      LoadBookmarkPostEvent event, Emitter<BookmarkState> emit) async {
    try {
      Response<dynamic> response = await _bookmarkRepository.getPostByUserName(
          username: event.username,
          page: event.page,
          limit: event.limit,
          tag: event.tag);

      ResultCount<Post> posts =
          ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkPostLoadedState(posts: posts));
      }
    } catch (error) {
      emit(const BookmarkLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  Future<void> _loadBookmarkSeries(
      LoadBookmarkSeriesEvent event, Emitter<BookmarkState> emit) async {
    try {
      Response<dynamic> response =
          await _bookmarkRepository.getSeriesByUserName(
        username: event.username,
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesPost> seriesPosts =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPosts.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkSeriesLoadedState(seriesPost: seriesPosts));
      }
    } catch (error) {
      emit(const BookmarkLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
