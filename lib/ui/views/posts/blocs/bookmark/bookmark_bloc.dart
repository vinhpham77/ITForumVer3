import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/bookmark_repository.dart';
import 'package:it_forum/ui/common/utils/common_utils.dart';

import '../../../../../dtos/post_user.dart';
import '../../../../../dtos/series_post.dart';
import '../../../../../dtos/series_post_user.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/user_repository.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  final UserRepository _userRepository = UserRepository();

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
        List<String> usernames =
            posts.resultList.map((e) => e.createdBy).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<PostUser> postUsers = convertPostUser(posts.resultList, users);

        ResultCount<PostUser> postUserResults =
            ResultCount<PostUser>(count: posts.count, resultList: postUsers);

        emit(BookmarkPostLoadedState(postUsers: postUserResults));
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
        List<String> usernames =
            seriesPosts.resultList.map((e) => e.createdBy!).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<SeriesPostUser> seriesPostUsers =
            convertSeriesPostUser(seriesPosts.resultList, users);

        ResultCount<SeriesPostUser> seriesPostUserResults =
            ResultCount<SeriesPostUser>(
                count: seriesPosts.count, resultList: seriesPostUsers);

        emit(BookmarkSeriesLoadedState(seriesPostUsers: seriesPostUserResults));
      }
    } catch (error) {
      emit(const BookmarkLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
