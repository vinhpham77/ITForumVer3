import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';

import '../../../../../dtos/post_user.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/post_repository.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository = PostRepository();
  final UserRepository _userRepository = UserRepository();

  PostBloc() : super(PostsInitialState()) {
    on<LoadPostsEvent>(_loadPosts);
  }

  Future<void> _loadPosts(LoadPostsEvent event, Emitter<PostState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.get(
          page: event.page, limit: event.limit, tag: event.tag);

      ResultCount<Post> posts =
          ResultCount.fromJson(response.data, Post.fromJson);

      if (posts.resultList.isEmpty) {
        emit(PostsEmptyState());
      } else {
        List<String> usernames =
        posts.resultList.map((e) => e.createdBy).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<PostUser> postUsers = convertPostUser(posts.resultList, users);

        ResultCount<PostUser> postUserResults = ResultCount<PostUser>(
            count: posts.count, resultList: postUsers);

        emit(PostsLoadedState(postUsers: postUserResults));
      }
    } catch (error) {
      emit(const PostsLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
