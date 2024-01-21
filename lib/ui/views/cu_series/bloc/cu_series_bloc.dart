import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_forum/dtos/series_dto.dart';
import 'package:it_forum/models/series.dart';
import 'package:it_forum/repositories/series_repository.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../dtos/post_user.dart';
import '../../../../dtos/result_count.dart';
import '../../../../dtos/series_post.dart';
import '../../../../models/post.dart';
import '../../../../models/user.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../repositories/comment_repository.dart';
import '../../../../repositories/image_repository.dart';
import '../../../../repositories/post_repository.dart';
import '../../../common/utils/common_utils.dart';

part 'cu_series_event.dart';
part 'cu_series_state.dart';

class CuSeriesBloc extends Bloc<CuSeriesEvent, CuSeriesState> {
  final AuthRepository _authRepository;
  final SeriesRepository _seriesRepository;
  final PostRepository _postRepository;
  final CommentRepository _commentRepository;
  final ImageRepository _imageRepository;

  CuSeriesBloc(
      {required AuthRepository authRepository,
      required PostRepository postRepository,
      required SeriesRepository seriesRepository,
      required ImageRepository imageRepository,
      required CommentRepository commentRepository})
      : _postRepository = postRepository,
        _authRepository = authRepository,
        _seriesRepository = seriesRepository,
        _imageRepository = imageRepository,
        _commentRepository = commentRepository,
        super(CuSeriesInitState()) {
    on<InitEmptySeriesEvent>(_initEmptySeries);
    on<LoadSeriesEvent>(_loadSeries);
    on<CuSeriesOperationEvent>(_cuSeries);
    on<SwitchModeEvent>(_switchMode);
    on<AddPostEvent>(_addPost);
    on<RemovePostEvent>(_removePost);
  }

  void _initEmptySeries(
      InitEmptySeriesEvent event, Emitter<CuSeriesState> emit) {
    emit(const CuSeriesEmptyState(
      seriesPost: null,
      isEditMode: true,
      postUsers: [],
      selectedPostUsers: [],
    ));
  }

  Future<void> _loadSeries(
      LoadSeriesEvent event, Emitter<CuSeriesState> emit) async {
    try {
      if (JwtPayload.sub == null) {
        emit(const UnAuthorizedState(
            message: "Bạn cần đăng nhập để thực hiện chức năng này"));
        return;
      }

      var userResponseFuture = _authRepository.verify();
      var seriesResponseFuture = _seriesRepository.getOne(event.id);
      var postResultCountJsonFuture =
          _postRepository.getByUser(JwtPayload.sub!);

      var results = await Future.wait([
        userResponseFuture,
        seriesResponseFuture,
        postResultCountJsonFuture
      ]);

      var userResponse = results[0];
      var seriesResponse = results[1];
      var postResultCountJson = results[2];

      var user = User.fromJson(userResponse.data);
      SeriesPost seriesPost = SeriesPost.fromJson(seriesResponse.data);
      ResultCount<Post> resultCount =
          ResultCount.fromJson(postResultCountJson.data, Post.fromJson);

      List<Post> posts = resultCount.resultList.map((e) => e).toList();
      List<PostUser> selectPostUsers = [];
      List<PostUser> postUsers = posts
          .map((post) => PostUser(
                post: post,
                user: user,
              ))
          .toList();

      postUsers.removeWhere((postUser) {
        if (seriesPost.postIds.contains(postUser.post.id)) {
          selectPostUsers.add(postUser);
          return true;
        }
        return false;
      });

      emit(CuSeriesLoadedState(
        seriesPost: seriesPost,
        isEditMode: true,
        postUsers: postUsers,
        selectedPostUsers: selectPostUsers,
      ));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên series này"));
        }
      }

      String message = getMessageFromException(error);
      emit(CuSeriesLoadErrorState(message: message));
    }
  }

  Future<void> _cuSeries(
      CuSeriesOperationEvent event, Emitter<CuSeriesState> emit) async {
    try {
      if (event.seriesDTO.isPrivate) {
        emit(CuPrivateSeriesWaitingState(
            seriesPost: event.seriesPost,
            isEditMode: event.isEditMode,
            selectedPostUsers: event.selectedPostUsers,
            postUsers: event.postUsers));
      } else {
        emit(CuPublicSeriesWaitingState(
            seriesPost: event.seriesPost,
            isEditMode: event.isEditMode,
            selectedPostUsers: event.selectedPostUsers,
            postUsers: event.postUsers));
      }

      Response<dynamic> response;
      if (event.isCreate) {
        response = await _seriesRepository.add(event.seriesDTO);
        Series series = Series.fromJson(response.data);
        await _commentRepository.create(response.data['id'], true);
        await _imageRepository.saveByContent(series.content);
        emit(SeriesCreatedState(id: series.id!));
      } else {
        response = await _seriesRepository.update(
            event.seriesPost!.id!, event.seriesDTO);
        Series series = Series.fromJson(response.data);
        await _imageRepository.deleteByContent(event.seriesPost!.content);
        await _imageRepository.saveByContent(series.content);
        emit(SeriesUpdatedState(id: series.id!));
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên series này"));
        }

        String message = getMessageFromException(error);
        emit(CuOperationErrorState(
            message: message,
            seriesPost: event.seriesPost,
            isEditMode: event.isEditMode,
            postUsers: event.postUsers,
            selectedPostUsers: event.selectedPostUsers));
      }
    }
  }

  void _switchMode(SwitchModeEvent event, Emitter<CuSeriesState> emit) {
    emit(SwitchModeState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      postUsers: event.postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }

  void _addPost(AddPostEvent event, Emitter<CuSeriesState> emit) {
    var postUsers = [...event.postUsers];
    postUsers.remove(event.postUser);
    event.selectedPostUsers.add(event.postUser);

    emit(AddedPostState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      postUsers: postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }

  void _removePost(RemovePostEvent event, Emitter<CuSeriesState> emit) {
    var postUsers = [...event.postUsers, event.postUser];
    event.selectedPostUsers.remove(event.postUser);
    emit(RemovedPostState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      postUsers: postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }
}
