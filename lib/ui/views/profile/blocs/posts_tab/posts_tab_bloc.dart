import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/result_count.dart';
import 'package:it_forum/repositories/post_repository.dart';

import '../../../../../dtos/post_user.dart';
import '../../../../../models/post.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/comment_repository.dart';
import '../../../../../repositories/image_repository.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../common/utils/common_utils.dart';

part 'posts_tab_event.dart';
part 'posts_tab_state.dart';

class PostsTabBloc extends Bloc<PostsTabEvent, PostsTabState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  final CommentRepository _commentRepository;
  final ImageRepository _imageRepository;

  PostsTabBloc(
      {required PostRepository postRepository,
      required UserRepository userRepository,
      required ImageRepository imageRepository,
      required CommentRepository commentRepository})
      : _postRepository = postRepository,
        _userRepository = userRepository,
        _imageRepository = imageRepository,
        _commentRepository = commentRepository,
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
        List<String> usernames =
            posts.resultList.map((e) => e.createdBy).toList();

        var userResponse = await _userRepository.getUsers(usernames);
        List<User> users = (userResponse.data as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();

        List<PostUser> postUsers = convertPostUser(posts.resultList, users);

        ResultCount<PostUser> postUserResults =
            ResultCount<PostUser>(count: posts.count, resultList: postUsers);
        emit(PostsLoadedState(postUsers: postUserResults));
      }
    } catch (error) {
      emit(const PostsLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<PostsTabState> emit) async {
    try {
      var deletePostResponse =
          await _postRepository.delete(event.postUser.post.id);

      if (deletePostResponse.statusCode == 204) {
        var deleteCommentFuture = _commentRepository.delete(event.postUser.post.id, false);
        var deleteImageFuture =  _imageRepository.deleteByContent(event.postUser.post.content);
        await Future.wait([deleteCommentFuture, deleteImageFuture]);
      }

      emit(PostsDeleteSuccessState(postUser: event.postUser));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(PostsTabErrorState(message: message, postUsers: event.postUsers));
    }
  }
}
