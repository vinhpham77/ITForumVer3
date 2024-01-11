part of 'cu_series_bloc.dart';

@immutable
sealed class CuSeriesState extends Equatable {
  const CuSeriesState();

  @override
  List<Object?> get props => [];
}

sealed class CuSeriesSubState extends CuSeriesState {
  final SeriesPost? seriesPost;
  final List<Post> posts;
  final List<Post> selectedPosts;
  final bool isEditMode;

  const CuSeriesSubState({
    required this.isEditMode,
    required this.seriesPost,
    required this.selectedPosts,
    required this.posts,
  });

  @override
  List<Object?> get props => [isEditMode, seriesPost, selectedPosts, posts];
}

final class CuSeriesInitState extends CuSeriesState {}

final class CuSeriesEmptyState extends CuSeriesSubState {
  const CuSeriesEmptyState({
    super.isEditMode = true,
    super.seriesPost,
    super.selectedPosts = const [],
    super.posts = const [],
  });
}

final class CuSeriesLoadedState extends CuSeriesSubState {
  const CuSeriesLoadedState(
      {super.isEditMode = true,
      required super.seriesPost,
      required super.selectedPosts,
      required super.posts});
}

sealed class CuSeriesErrorState extends CuSeriesState {
  final String message;

  const CuSeriesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SeriesNotFoundState extends CuSeriesErrorState {
  const SeriesNotFoundState({required super.message});
}

final class UnAuthorizedState extends CuSeriesErrorState {
  const UnAuthorizedState({required super.message});
}

final class CuSeriesLoadErrorState extends CuSeriesErrorState {
  const CuSeriesLoadErrorState({required super.message});
}

final class CuOperationErrorState extends CuSeriesSubState {
  final String message;

  const CuOperationErrorState({
    required this.message,
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });

  @override
  List<Object?> get props => [
        message,
        super.isEditMode,
        super.seriesPost,
        super.selectedPosts,
        super.posts
      ];
}

final class SeriesCreatedState extends CuSeriesState {
  final int id;

  const SeriesCreatedState({required this.id});

  @override
  List<Object> get props => [id];
}

final class SeriesUpdatedState extends CuSeriesState {
  final int id;

  const SeriesUpdatedState({required this.id});

  @override
  List<Object> get props => [id];
}

final class SwitchModeState extends CuSeriesSubState {
  const SwitchModeState({
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });
}

final class AddedPostState extends CuSeriesSubState {
  const AddedPostState({
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });
}

final class RemovedPostState extends CuSeriesSubState {
  const RemovedPostState({
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });
}

final class CuPrivateSeriesWaitingState extends CuSeriesSubState {
  const CuPrivateSeriesWaitingState({
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });
}

final class CuPublicSeriesWaitingState extends CuSeriesSubState {
  const CuPublicSeriesWaitingState({
    required super.isEditMode,
    required super.seriesPost,
    required super.selectedPosts,
    required super.posts,
  });
}