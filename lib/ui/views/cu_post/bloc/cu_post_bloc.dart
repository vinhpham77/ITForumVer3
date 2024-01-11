import 'package:it_forum/dtos/result_count.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../dtos/post_dto.dart';
import '../../../../models/post.dart';
import '../../../../models/tag.dart';
import '../../../../repositories/post_repository.dart';
import '../../../../repositories/tag_repository.dart';
import '../../../common/utils/message_from_exception.dart';

part 'cu_post_event.dart';

part 'cu_post_state.dart';

class CuPostBloc extends Bloc<CuPostEvent, CuPostState> {
  final PostRepository _postRepository;
  final TagRepository _tagRepository;

  CuPostBloc({
    required PostRepository postRepository,
    required TagRepository tagRepository,
  })  : _postRepository = postRepository,
        _tagRepository = tagRepository,
        super(CuPostInitState()) {
    on<InitEmptyPostEvent>(_initEmptyPost);
    on<LoadPostEvent>(_loadPost);
    on<CuPostOperationEvent>(_cuPost);
    on<SwitchModeEvent>(_switchMode);
    on<AddTagEvent>(_addTag);
    on<RemoveTagEvent>(_removeTag);
  }

  Future<void> _initEmptyPost(
      InitEmptyPostEvent event, Emitter<CuPostState> emit) async {
    try {
      if (JwtPayload.sub == null) {
        emit(const UnAuthorizedState(
            message: "Bạn cần đăng nhập để thực hiện chức năng này"));
        return;
      }

      var tagsResponse = await _tagRepository.get();
      ResultCount<Tag> resultCount =
          ResultCount.fromJson(tagsResponse.data, Tag.fromJson);
      List<Tag> tags = resultCount.resultList;
      List<Tag> selectedTags = [];

      if (event.isQuestion) {
        var tag = tags.firstWhere((tag) => tag.name == 'HoiDap');
        tags.remove(tag);
        selectedTags.add(tag);
      }

      emit(CuPostEmptyState(
        isQuestion: event.isQuestion,
        isEditMode: true,
        post: null,
        selectedTags: selectedTags,
        tags: tags,
      ));
    } catch (error) {
      if (error is DioException) {
        String message = getMessageFromException(error);
        emit(CuPostLoadErrorState(message: message));
      }
    }
  }

  Future<void> _loadPost(LoadPostEvent event, Emitter<CuPostState> emit) async {
    try {
      if (JwtPayload.sub == null) {
        emit(const UnAuthorizedState(
            message: "Bạn cần đăng nhập để thực hiện chức năng này"));
        return;
      }

      var response = await _postRepository.getOne(event.id);
      Post post = Post.fromJson(response.data);

      var tagsResponse = await _tagRepository.get();
      ResultCount<Tag> resultCount =
          ResultCount.fromJson(tagsResponse.data, Tag.fromJson);

      List<Tag> tags = resultCount.resultList;

      bool isQuestion = false;
      List<Tag> selectedTags = post.tags.map((post) {
        var tag = tags.firstWhere((tag) => tag.name == post.name);
        tags.remove(tag);
        if (post.name == 'HoiDap') {
          isQuestion = true;
        }
        return tag;
      }).toList();

      emit(CuPostLoadedState(
        isQuestion: isQuestion,
        isEditMode: true,
        post: post,
        selectedTags: selectedTags,
        tags: tags,
      ));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const PostNotFoundState(message: "Không tìm thấy bài viết"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên bài viết này"));
        }

        String message = getMessageFromException(error);
        emit(CuPostLoadErrorState(message: message));
      }
    }
  }

  Future<void> _cuPost(
      CuPostOperationEvent event, Emitter<CuPostState> emit) async {
    try {
      if (event.postDTO.isPrivate) {
        emit(CuPrivatePostWaitingState(
            post: event.post,
            isEditMode: event.isEditMode,
            selectedTags: event.selectedTags,
            tags: event.tags,
            isQuestion: event.isQuestion));
      } else {
        emit(CuPublicPostWaitingState(
            post: event.post,
            isEditMode: event.isEditMode,
            selectedTags: event.selectedTags,
            tags: event.tags,
            isQuestion: event.isQuestion));
      }

      var postDTO = event.postDTO;
      Response<dynamic> response;

      if (event.isCreate) {
        response = await _postRepository.add(postDTO);
      } else {
        response = await _postRepository.update(event.post!.id, postDTO);
      }

      Post post = Post.fromJson(response.data);

      emit(CuPostOperationSuccessState(post: post));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const PostNotFoundState(message: "Không tìm thấy bài viết"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên bài viết này"));
        }
        String message = getMessageFromException(error);

        event.post?.content = event.postDTO.content;
        emit(CuOperationErrorState(
            message: message,
            post: event.post,
            isEditMode: event.isEditMode,
            selectedTags: event.selectedTags,
            tags: event.tags,
            isQuestion: event.isQuestion));
      }
    }
  }

  void _switchMode(SwitchModeEvent event, Emitter<CuPostState> emit) {
    emit(SwitchModeState(
      isQuestion: event.isQuestion,
      isEditMode: event.isEditMode,
      post: event.post,
      selectedTags: event.selectedTags,
      tags: event.tags,
    ));
  }

  void _addTag(AddTagEvent event, Emitter<CuPostState> emit) {
    List<Tag> selectedTags = [...event.selectedTags, event.tag];
    event.tags.remove(event.tag);
    emit(CuPostLoadedState(
      isQuestion: _isQuestion(selectedTags),
      isEditMode: event.isEditMode,
      post: event.post,
      selectedTags: selectedTags,
      tags: event.tags,
    ));
  }

  void _removeTag(RemoveTagEvent event, Emitter<CuPostState> emit) {
    List<Tag> selectedTags = [...event.selectedTags];
    selectedTags.remove(event.tag);
    event.tags.add(event.tag);

    emit(CuPostLoadedState(
      isQuestion: _isQuestion(selectedTags),
      isEditMode: event.isEditMode,
      post: event.post,
      selectedTags: selectedTags,
      tags: event.tags,
    ));
  }

  bool _isQuestion(List<Tag> tags) {
    return tags.any((tag) => tag.name == 'HoiDap');
  }
}
