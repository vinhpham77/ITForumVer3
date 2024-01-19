import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';

import '../../../../../dtos/series_post.dart';
import '../../../../../models/post.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/series_repository.dart';
import '../../../../dtos/post_user.dart';
import '../../../../dtos/series_post_user.dart';
import '../../../../models/user.dart';
import '../../../../repositories/user_repository.dart';
import '../../../common/utils/common_utils.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostRepository _postRepository = PostRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();
  final UserRepository _userRepository = UserRepository();

  SearchBloc() : super(FollowInitialState()) {
    on<LoadPostsEvent>(_loadPostsSearch);
    on<LoadSeriesEvent>(_loadSeriesSearch);
  }

  Future<void> _loadPostsSearch(
      LoadPostsEvent event, Emitter<SearchState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getSearch(
          fieldSearch: event.fieldSearch,
          searchContent: event.searchContent,
          sort: event.sort,
          sortField: event.sortField,
          page: event.page,
          limit: event.limit);

      ResultCount<Post> posts =
          ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(FollowEmptyState());
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
        emit(PostLoadedState(postUsers: postUserResults));
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
          fieldSearch: event.fieldSearch,
          searchContent: event.searchContent,
          sort: event.sort,
          sortField: event.sortField,
          page: event.page,
          limit: event.limit);

      ResultCount<SeriesPost> seriesPosts =
          ResultCount.fromJson(response.data, SeriesPost.fromJson);

      if (seriesPosts.resultList.isEmpty) {
        emit(FollowEmptyState());
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

        emit(SeriesLoadedState(seriesPostUsers: seriesPostUserResults));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
