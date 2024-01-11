import 'package:it_forum/dtos/series_dto.dart';
import 'package:it_forum/models/series.dart';
import 'package:it_forum/repositories/series_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../dtos/result_count.dart';
import '../../../../dtos/series_post.dart';
import '../../../../models/post.dart';
import '../../../../repositories/post_repository.dart';
import '../../../common/utils/message_from_exception.dart';

part 'cu_series_event.dart';

part 'cu_series_state.dart';

class CuSeriesBloc extends Bloc<CuSeriesEvent, CuSeriesState> {
  final SeriesRepository _seriesRepository;
  final PostRepository _postRepository;

  CuSeriesBloc(
      {required PostRepository postRepository,
      required SeriesRepository seriesRepository})
      : _postRepository = postRepository,
        _seriesRepository = seriesRepository,
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
      posts: [],
      selectedPosts: [],
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

      var response = await _seriesRepository.getOne(event.id);
      SeriesPost seriesPost = SeriesPost.fromJson(response.data);

      var resultCountJson = await _postRepository.getByUser(JwtPayload.sub!);
      ResultCount<Post> resultCount =
          ResultCount.fromJson(resultCountJson.data, Post.fromJson);
      List<Post> posts = resultCount.resultList.map((e) => e).toList();
      List<Post> selectedPosts = [];
      posts.removeWhere((postUser) {
        if (seriesPost.postIds.contains(postUser.id)) {
          selectedPosts.add(postUser);
          return true;
        }
        return false;
      });

      emit(CuSeriesLoadedState(
        seriesPost: seriesPost,
        isEditMode: true,
        posts: posts,
        selectedPosts: selectedPosts,
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
            selectedPosts: event.selectedPosts,
            posts: event.posts));
      } else {
        emit(CuPublicSeriesWaitingState(
            seriesPost: event.seriesPost,
            isEditMode: event.isEditMode,
            selectedPosts: event.selectedPosts,
            posts: event.posts));
      }

      Response<dynamic> response;
      if (event.isCreate) {
        response = await _seriesRepository.add(event.seriesDTO);
        Series series = Series.fromJson(response.data);
        emit(SeriesCreatedState(id: series.id!));
      } else {
        response = await _seriesRepository.update(
            event.seriesPost!.id!, event.seriesDTO);
        Series series = Series.fromJson(response.data);
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
            posts: event.posts,
            selectedPosts: event.selectedPosts));
      }
    }
  }

  void _switchMode(SwitchModeEvent event, Emitter<CuSeriesState> emit) {
    emit(SwitchModeState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      posts: event.posts,
      selectedPosts: event.selectedPosts,
    ));
  }

  void _addPost(AddPostEvent event, Emitter<CuSeriesState> emit) {
    var posts = [...event.posts];
    posts.remove(event.post);
    event.selectedPosts.add(event.post);

    emit(AddedPostState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      posts: posts,
      selectedPosts: event.selectedPosts,
    ));
  }

  void _removePost(RemovePostEvent event, Emitter<CuSeriesState> emit) {
    var posts = [...event.posts, event.post];
    event.selectedPosts.remove(event.post);
    emit(RemovedPostState(
      seriesPost: event.seriesPost,
      isEditMode: event.isEditMode,
      posts: posts,
      selectedPosts: event.selectedPosts,
    ));
  }
}
