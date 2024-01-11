import 'package:it_forum/dtos/result_count.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/post.dart';
import '../../../../../repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository =
      PostRepository();

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
        emit(PostsLoadedState(posts: posts));
      }
    } catch (error) {
      emit(const PostsLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
