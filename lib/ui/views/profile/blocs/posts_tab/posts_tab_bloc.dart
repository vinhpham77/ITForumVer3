import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/post.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'posts_tab_event.dart';
part 'posts_tab_state.dart';

class PostsTabBloc extends Bloc<PostsTabEvent, PostsTabState> {
  final PostRepository _postRepository;

  PostsTabBloc({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(PostsInitialState()) {
    on<LoadPostsEvent>(_loadPosts);
    on<ConfirmDeleteEvent>(_confirmDelete);
  }

  Future<void> _loadPosts(
      LoadPostsEvent event, Emitter<PostsTabState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getByUser(
        event.username,
        page: event.page,
        size: event.limit,
        tag: event.isQuestion ? 'HoiDap' : null,
      );

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

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<PostsTabState> emit) async {
    try {
      await _postRepository.delete(event.post.id);
      emit(PostsDeleteSuccessState(post: event.post));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(PostsTabErrorState(message: message, posts: event.posts));
    }
  }
}
