import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/bookmark_repository.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:it_forum/repositories/series_repository.dart';
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
  final PostRepository _postRepository = PostRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();

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
      ResultCount<int> postIds = ResultCount(resultList: List<int>.from(response.data['resultList']), count: response.data['count']);


      if (postIds.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        response = await _postRepository.getByIds(
            ids: postIds.resultList);
        List<Post> posts = (response.data as List<dynamic>)
            .map((e) => Post.fromJson(e))
            .toList();
        List<String> usernames =
            posts.map((e) => e.createdBy).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<PostUser> postUsers = convertPostUser(posts, users);

        ResultCount<PostUser> postUserResults =
            ResultCount<PostUser>(count: postIds.count, resultList: aggregationPost(postIds.resultList, postUsers));

        emit(BookmarkPostLoadedState(postUsers: postUserResults));
      }
    } catch (error) {
      String message = "Có lỗi xảy ra. Vui lòng thử lại sau!";
      if (error is DioError) {
        if (error.response?.statusCode == 404) {
          message = "Chưa có bookmark!";
        }
      }
      emit(BookmarkLoadErrorState(message: message));
    }
  }

  Future<void> _loadBookmarkSeries(
      LoadBookmarkSeriesEvent event, Emitter<BookmarkState> emit) async {
    try {
      Response<dynamic> response = await _bookmarkRepository.getSeriesByUserName(
          username: event.username,
          page: event.page,
          limit: event.limit);

      ResultCount<int> seriesIds = ResultCount(resultList: List<int>.from(response.data['resultList']), count: response.data['count']);

      if (seriesIds.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        response = await _seriesRepository.getByIds(
            ids: seriesIds.resultList);
        List<SeriesPost> seriesPosts = (response.data as List<dynamic>)
            .map((e) => SeriesPost.fromJson(e))
            .toList();
        List<String> usernames =
            seriesPosts.map((e) => e.createdBy!).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<SeriesPostUser> seriesPostUsers =
            convertSeriesPostUser(seriesPosts, users);

        ResultCount<SeriesPostUser> seriesPostUserResults =
            ResultCount<SeriesPostUser>(
                count: seriesIds.count, resultList: aggregationSeries(seriesIds.resultList, seriesPostUsers));
        emit(BookmarkSeriesLoadedState(seriesPostUsers: seriesPostUserResults));
      }
    } catch (error) {
      String message = "Có lỗi xảy ra. Vui lòng thử lại sau!";
      if (error is DioError) {
        if (error.response?.statusCode == 404) {
          message = "Chưa có bookmark!";
        }
      }
      emit(BookmarkLoadErrorState(message: message));
    }
  }
}
